module GemDating
  class Cli
    SUCCESS = 0
    GENERAL_ERROR = 1

    HELP_TEXT =
      <<~HELP
        gem_dating [--help | -h] [<GEMFILE_FILEPATH>]

        GEMFILE_FILEPATH defaults to ./Gemfile if not provided.

        Options:
          --help, -h, -?  Show this help message
          --older-than=<AGE>, --ot=<AGE>    Filter gems updated within the last X (e.g. 2y, 1m, 4w, 10d)
      HELP

    def initialize(argv = [])
      args, file_path = argv.partition { |arg| (arg =~ /--\w+/) || (arg =~ /(-[a-z])/) }

      @args = args
      @file_path = file_path.first
      @options = parse_args
    end

    def run
      if @options[:help]
        $stdout << HELP_TEXT
        return SUCCESS
      end

      unless @file_path
        current_directory = Dir.pwd
        file_path = File.join(current_directory, "Gemfile")

        if File.exist?(file_path)
          @file_path = file_path
        else
          $stdout << HELP_TEXT
          return GENERAL_ERROR
        end
      end

      $stdout << GemDating.from_file(@file_path, @options).table_print << "\n"

      SUCCESS
    end

    private

    def parse_args(args = @args)
      options = {}
      options[:help] = true if (args & %w[-h --help -?]).any?
      if (older_than = args.find { |arg| arg.start_with?("--older-than=", "--ot=") })
        options[:older_than] = older_than.split("=").last
      end
      options
    end
  end
end
