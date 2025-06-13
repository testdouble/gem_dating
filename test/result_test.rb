require "test_helper"
require "date"

class TestResult < Minitest::Test

  def build_mock_spec(name:, version:, date:)
    spec = Gem::Specification.new
    spec.name = name
    spec.version = Gem::Version.new(version)
    spec.date = date
    spec
  end

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

    today = Date.today

    @recent_gem = build_mock_spec(name: "recent", version: "1.0", date: today - 10)
    @months_old_gem = build_mock_spec(name: "months_old", version: "1.0", date: today << 2)
    @year_old_gem = build_mock_spec(name: "year_old", version: "1.0", date: today - 400)

    @date_result = GemDating::Result.new([
      @recent_gem,
      @months_old_gem,
      @year_old_gem
    ])
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

  def test_cut_off_parsing_years
    @date_result.older_than("1y")

    assert_equal @date_result.specs.include?(@year_old_gem), true
    assert_equal @date_result.specs.include?(@months_old_gem), false
    assert_equal @date_result.specs.include?(@recent_gem), false
  end

  def test_cut_off_parsing_months
    @date_result.older_than("1m")

    assert_equal @date_result.specs.include?(@year_old_gem), true
    assert_equal @date_result.specs.include?(@months_old_gem), true
    assert_equal @date_result.specs.include?(@recent_gem), false
  end

  def test_cut_off_parsing_weeks
    @date_result.older_than("3w")

    assert_equal @date_result.specs.include?(@year_old_gem), true
    assert_equal @date_result.specs.include?(@months_old_gem), true
    assert_equal @date_result.specs.include?(@recent_gem), false
  end

  def test_cut_off_parsing_days
    @date_result.older_than("7d")

    assert_equal @date_result.specs.include?(@year_old_gem), true
    assert_equal @date_result.specs.include?(@months_old_gem), true
    assert_equal @date_result.specs.include?(@recent_gem), true
  end

  def test_cut_off_invalid_format_raises
    assert_raises(ArgumentError) { @date_result.older_than("5x") }
    assert_raises(ArgumentError) { @date_result.older_than("abc") }
    assert_raises(ArgumentError) { @date_result.older_than("") }
  end

  def test_sort_by_name_asc
    result = GemDating::Result.new([@spec1, @spec2])
    sorted = result.sort(sort_by: "name", order: "asc")

    assert_equal ["hi", "there"], sorted.to_a.map(&:name)
  end

  def test_sort_by_name_desc
    result = GemDating::Result.new([@spec1, @spec2])
    sorted = result.sort(sort_by: "name", order: "desc")

    assert_equal ["there", "hi"], sorted.to_a.map(&:name)
  end

  def test_sort_by_date_asc
    result = GemDating::Result.new([@spec1, @spec2])
    sorted = result.sort(sort_by: "date", order: "asc")

    assert_equal ["there", "hi"], sorted.to_a.map(&:name)
  end

  def test_sort_by_date_desc
    result = GemDating::Result.new([@spec1, @spec2])
    sorted = result.sort(sort_by: "date", order: "desc")

    assert_equal ["hi", "there"], sorted.to_a.map(&:name)
  end

  def test_sort_defaults
    result = GemDating::Result.new([@spec2, @spec1])
    sorted = result.sort

    # Default sort is by name in ascending order
    assert_equal ["hi", "there"], sorted.to_a.map(&:name)
  end
end
