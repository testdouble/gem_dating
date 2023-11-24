module GemDating
  class Cli
    SUCCESS = 0
    GENERAL_ERROR = 1

    HELP_TEXT =
      <<~HELP
        Usage: gem_dating [--help | -h] [<GEMFILE_FILEPATH>]
      HELP

    def initialize(argv)
      args, file_path = argv.partition { |arg| (arg =~ /--\w+/) || (arg =~ /(-[a-z])/) }

      @args = args
      @file_path = file_path.first
    end

    def run
      if (@args & ['-h', '--help']).any?
        $stdout << HELP_TEXT
        return SUCCESS
      end

      unless @file_path
        $stdout << HELP_TEXT
        return GENERAL_ERROR
      end

      $stdout << GemDating.from_file(@file_path).table_print << "\n"

      SUCCESS
    end
  end
end
