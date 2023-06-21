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
  end

  def test_gemfile
    exit_code = nil

    rubygems = Mocktail.of(GemDating::Rubygems)

    stubs { |m| rubygems.fetch(m.is_a?(Array)) }.with { [@spec1, @spec2, @spec3] }

    stdout, _stderr = capture_io do
      exit_code = GemDating::Cli.new(["test/Gemfile.example"]).run
    end

    expected_out = <<~EXPECTED
      NAME        | VERSION | DATE      
      ------------|---------|-----------
      banana-client | 21.1.0   | 1990-08-21
      rails-on-rubies       | 70.0.5   | 2123-05-24
      giraffeql     | 0.0.2227  | 2023-05-17
    EXPECTED

    assert_equal 0, exit_code
    assert_equal expected_out, stdout
  end

  def test_no_args_prints_help
    exit_code = nil

    stdout, _stderr = capture_io do
      exit_code = GemDating::Cli.new([]).run
    end

    expected_out =
      <<~EXPECTED
        Usage: gem_dating [GEMFILE_FILEPATH]
      EXPECTED

    assert_equal 1, exit_code
    assert_equal expected_out, stdout
  end

  def test_bad_filepath
    assert_raises Errno::ENOENT do
      GemDating::Cli.new(["test/Gemfile.nope"]).run
    end
  end
end
