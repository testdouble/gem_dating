require "test_helper"
require "date"

class GemDating::CliTest < Minitest::Test
  def setup
    @spec1 = Gem::Specification.new do |s|
      s.name = "rest-client"
      s.version = "2.1.0"
      s.date = DateTime.parse("2019-08-21")
    end
    @spec2 = Gem::Specification.new do |s|
      s.name = "rails"
      s.version = "7.0.5"
      s.date = DateTime.parse("2023-05-24")
    end
    @spec3 = Gem::Specification.new do |s|
      s.name = "graphql"
      s.version = "2.0.22"
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
      rest-client | 2.1.0   | 2019-08-21
      rails       | 7.0.5   | 2023-05-24
      graphql     | 2.0.22  | 2023-05-17
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
    exit_code = nil

    assert_raises Errno::ENOENT do
      _stdout, stderr = capture_io do
        exit_code = GemDating::Cli.new(["test/Gemfile.nope"]).run
      end

      assert_equal exit_code, 2
      assert_includes stderr, "No such file or directory @ rb_sysopen - test/bad_file.txt\n"
    end
  end
end
