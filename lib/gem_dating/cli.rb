module GemDating
  class Cli
    SUCCESS_CODE = 0

    def initialize(argv)
      @argv = argv
    end

    def run
      path = @argv.first

      $stdout << GemDating.from_file(path).table_print << "\n"

      SUCCESS_CODE
    end
  end
end
