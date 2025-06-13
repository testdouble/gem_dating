require "table_print"

module GemDating
  class Result
    attr_reader :specs
    def initialize(specs)
      @specs = specs
    end

    def to_a
      specs
    end

    def to_h
      specs.each_with_object({}) do |spec, result|
        result[spec.name] = {
          "name" => spec.name,
          "version" => spec.version.to_s,
          "date" => spec.date.strftime("%Y-%m-%d")
        }
      end
    end

    def table_print
      TablePrint::Printer.table_print(specs, [:name, :version, {date: {time_format: "%Y-%m-%d", width: 10}}]).encode("utf-8")
    end

    def older_than(date)
      specs.select! { |spec| spec.date.to_date < self.cut_off(date) }
    end

    private

    def cut_off(date)
      return unless date
      curr_date = Date.today

      number = date[0..-2].to_i
      unit = date[-1]

      case unit
      when "y"
        curr_date << (12 * number)
      when "m"
        curr_date << number
      when "w"
        curr_date - (number * 7)
      when "d"
        curr_date - number
      else
        raise ArgumentError, "Invalid date format: #{date}"
      end
    end
  end
end
