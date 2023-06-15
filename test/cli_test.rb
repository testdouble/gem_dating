require "test_helper"

class GemDating::CliTest < Minitest::Test

  def test_from_gemfile
    exit_code = nil

    stdout, _stderr = capture_subprocess_io do
      exit_code = system("ruby exe/gem_dating test/Gemfile.example")
    end

    assert_equal exit_code, true
    assert_equal stdout, File.read("test/example_output.txt")
  end

  def test_bad_filepath
    exit_code = nil

    stdout, _stderr = capture_subprocess_io do
      exit_code = system("ruby exe/gem_dating test/bad_file.txt")
    end

    assert_equal exit_code, false
    assert_includes _stderr, "No such file or directory @ rb_sysopen - test/bad_file.txt\n"
  end
end
