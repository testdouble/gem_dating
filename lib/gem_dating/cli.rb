module GemDating
  class Cli
    SUCCESS = 0
    GENERAL_ERROR = 1

    def initialize(argv)
      @argv = argv
    end

    def run
      if @argv.empty?
        $stdout << "Usage: gem_dating [GEMFILE_FILEPATH]\n"
        return GENERAL_ERROR
      end

      path = @argv.first

      $stdout << GemDating.from_file(path).table_print << "\n"

      SUCCESS
    end
  end
end
