require "test_helper"
require "date"

class TestResult < Minitest::Test
  def setup
    @spec1 = Gem::Specification.new do |s|
      s.name = "hi"
      s.version = "42.42"
      s.date = DateTime.parse("2015-09-18")
    end
    @spec2 = Gem::Specification.new do |s|
      s.name = "there"
      s.version = "1.27.0.01"
      s.date = DateTime.parse("2009-09-02")
    end
    @result = GemDating::Result.new([@spec1, @spec2])
  end

  def test_specs
    assert_equal [@spec1, @spec2], @result.specs
    assert_equal [@spec1, @spec2], @result.to_a
  end

  def test_hash
    expected = {
      "hi" => {
        "name" => "hi",
        "version" => "42.42",
        "date" => "2015-09-18"
      },
      "there" => {
        "name" => "there",
        "version" => "1.27.0.01",
        "date" => "2009-09-02"
      }
    }
    assert_equal expected, @result.to_h
  end

  def test_table
    expected = <<-TEXT
      NAME  | VERSION   | DATE
      ------|-----------|-----------
      hi    | 42.42     | 2015-09-18
      there | 1.27.0.01 | 2009-09-02
    TEXT

    table = @result.table_print

    expected.split.each_with_index do |line, index|
      assert_equal line.strip, table.split[index].strip
    end
  end
end
