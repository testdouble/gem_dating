module GemDating
  class Input
    def self.string(s)
      new(s)
    end

    def self.file(path)
      new(IO.read(path))
    end

    attr_reader :contents

    def initialize(contents)
      @contents = contents
    end

    def gems
      lines = contents.split("\n")
      lines.each_with_object([]) do |line, gems|
        line = gem_line(line.strip)
        gems << cleanup(line) if line
      end
    end

    def gem_line(line)
      return if line.strip == "end"
      return if line =~ /^\s*#/

      if line.start_with? "gem("
        line.split("(")[1].split(",")[0]
      elsif line.start_with? "gem"
        line.split[1].split(",")[0]
      elsif line.split.length == 1
        line
      end
    end

    def cleanup(line)
      # "foo",
      # 'hi'
      line.strip.chomp(",").chomp("'").chomp('"').delete_prefix("'").delete_prefix('"')
    end
  end
end
