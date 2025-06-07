require 'date'

module GemDating
  class Rubygems
    def self.fetch(...)
      new.fetch(...)
    end

    def fetch(gems, date)
      specs = gems.map do |gem|
        Gem.latest_spec_for(gem) || unknown_version(gem)
      end

      return specs unless date

      cutoff = cut_off(date)
      specs.select { |s| s.date.to_date < cutoff }
    end

    def unknown_version(gemname)
      Gem::Specification.new do |s|
        s.name = gemname
        s.version = "0.0.0.UNKNOWN"
        s.date = "1970-01-01"
      end
    end

    private
    def cut_off(date)
      return unless date
      curr_date = Date.today
      case date
      when /\A(\d+)y\z/
        number = $1.to_i
        return curr_date << (12 * number)

      when /\A(\d+)m\z/
        number = $1.to_i
        return curr_date << number

      when /\A(\d+)w\z/
        number = $1.to_i
        return curr_date - (number * 7)

      when /\A(\d+)d\z/
        number = $1.to_i
        return curr_date - number

      else
        raise ArgumentError, "Invalid date format: #{date}"
      end
    end
  end
end
