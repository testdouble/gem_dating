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
  end
end
