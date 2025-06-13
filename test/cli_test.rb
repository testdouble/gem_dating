require "test_helper"
require "date"

class GemDating::CliTest < Minitest::Test
  def setup
    @spec1 = Gem::Specification.new do |s|
      s.name = "banana-client"
      s.version = "21.1.0"
      s.date = DateTime.parse("1990-08-21")
    end
    @spec2 = Gem::Specification.new do |s|
      s.name = "rails-on-rubies"
      s.version = "70.0.5"
      s.date = DateTime.parse("2123-05-24")
    end
    @spec3 = Gem::Specification.new do |s|
      s.name = "giraffeql"
      s.version = "0.0.2227"
      s.date = DateTime.parse("2023-05-17")
    end

    @tempdir = Dir.mktmpdir("gem_dating_test")

    Mocktail.replace(GemDating::Rubygems)
    stubs { |m| GemDating::Rubygems.fetch(m.is_a(Array)) }.with { [@spec1, @spec2, @spec3] }
  end

  def teardown
    super
    FileUtils.rm_rf @tempdir
    Mocktail.reset
  end

  def test_gemfile
    exit_code = nil

    stdout, _stderr = capture_io do
      exit_code = GemDating::Cli.new(["test/Gemfile.example"]).run
    end

    expected_out = <<~EXPECTED
      NAME            | VERSION  | DATE      
      ----------------|----------|-----------
      banana-client   | 21.1.0   | 1990-08-21
      giraffeql       | 0.0.2227 | 2023-05-17
      rails-on-rubies | 70.0.5   | 2123-05-24
    EXPECTED

    assert_equal 0, exit_code
    assert_equal expected_out, stdout
  end

  def test_default_to_existing_relative_gemfile
    FileUtils.copy("test/Gemfile.example", "#{@tempdir}/Gemfile")

    Dir.chdir(@tempdir) do
      exit_code = nil

      stdout, _stderr = capture_io do
        exit_code = GemDating::Cli.new.run
      end

      expected_out = <<~EXPECTED
        NAME            | VERSION  | DATE      
        ----------------|----------|-----------
        banana-client   | 21.1.0   | 1990-08-21
        giraffeql       | 0.0.2227 | 2023-05-17
        rails-on-rubies | 70.0.5   | 2123-05-24
      EXPECTED

      assert_equal 0, exit_code
      assert_equal expected_out, stdout
    end
  end

  def test_no_default_gemfile
    Dir.chdir(@tempdir) do
      exit_code = nil

      stdout, _stderr = capture_io do
        exit_code = GemDating::Cli.new([]).run
      end

      expected_out = GemDating::Cli::HELP_TEXT

      assert_equal 1, exit_code
      assert_equal expected_out, stdout
    end
  end

  def test_bad_filepath
    assert_raises Errno::ENOENT do
      GemDating::Cli.new(["test/Gemfile.nope"]).run
    end
  end

  def test_help_option
    exit_codes = []

    stdout, _stderr = capture_io do
      ["--help", "-h"].each do |help_option|
        exit_codes << GemDating::Cli.new([help_option]).run
      end
    end

    expected_out = GemDating::Cli::HELP_TEXT

    assert_equal [0], exit_codes.uniq
    assert_includes expected_out, stdout.split("\n").first
    assert_includes expected_out, stdout.split("\n").last
  end

  def test_parse_args
    cli = GemDating::Cli.new(["--help", "--older-than=2y"])
    assert_equal({help: true, older_than: "2y"}, cli.send(:parse_args))

    cli = GemDating::Cli.new(["--json"])
    assert_equal({json: true}, cli.send(:parse_args))

    cli = GemDating::Cli.new([])
    assert_equal({}, cli.send(:parse_args))
  end

  def test_sort_by_name_asc
    exit_code = nil

    stdout, _stderr = capture_io do
      exit_code = GemDating::Cli.new(["test/Gemfile.example", "--sort-by=name", "--order=asc"]).run
    end

    expected_out = <<~EXPECTED
      NAME            | VERSION  | DATE      
      ----------------|----------|-----------
      banana-client   | 21.1.0   | 1990-08-21
      giraffeql       | 0.0.2227 | 2023-05-17
      rails-on-rubies | 70.0.5   | 2123-05-24
    EXPECTED

    assert_equal 0, exit_code
    assert_equal expected_out, stdout
  end

  def test_sort_by_date_desc
    exit_code = nil

    stdout, _stderr = capture_io do
      exit_code = GemDating::Cli.new(["test/Gemfile.example", "--sort-by=date", "--order=desc"]).run
    end

    expected_out = <<~EXPECTED
      NAME            | VERSION  | DATE      
      ----------------|----------|-----------
      rails-on-rubies | 70.0.5   | 2123-05-24
      giraffeql       | 0.0.2227 | 2023-05-17
      banana-client   | 21.1.0   | 1990-08-21
    EXPECTED

    assert_equal 0, exit_code
    assert_equal expected_out, stdout
  end

  def test_json_output
    exit_code = nil

    stdout, _stderr = capture_io do
      exit_code = GemDating::Cli.new(["test/Gemfile.example", "--json"]).run
    end

    expected_data = {
      "banana-client" => {
        "name" => "banana-client",
        "version" => "21.1.0",
        "date" => "1990-08-21"
      },
      "giraffeql" => {
        "name" => "giraffeql",
        "version" => "0.0.2227",
        "date" => "2023-05-17"
      },
      "rails-on-rubies" => {
        "name" => "rails-on-rubies",
        "version" => "70.0.5",
        "date" => "2123-05-24"
      }
    }

    assert_equal 0, exit_code
    assert_equal expected_data, JSON.parse(stdout)
  end
end
