module GemDating
  class Rubygems
    def self.fetch(...)
      new.fetch(...)
    end

    def fetch(gems)
      gems.map do |gem|
        Gem.latest_spec_for(gem) || unknown_version(gem)
      end
    end

    def unknown_version(gemname)
      Gem::Specification.new do |s|
        s.name = gemname
        s.version = "0.0.0.UNKNOWN"
        s.date = "1970-01-01"
      end
    end
  end
end
