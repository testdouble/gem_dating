require "test_helper"
require "date"

class GemDating::RubygemsTest < Minitest::Test
  def build_mock_spec(name:, version:, date:)
    spec = Gem::Specification.new
    spec.name = name
    spec.version = Gem::Version.new(version)
    spec.date = date
    spec
  end

  def test_fetch_returns_all_gems_when_no_date
    specs = {
      "foo" => build_mock_spec(name: "foo", version: "1.0", date: Date.new(2023,1,1)),
      "bar" => build_mock_spec(name: "bar", version: "2.0", date: Date.new(2023,2,1))
    }

    Gem.stub :latest_spec_for, ->(name) { specs[name] } do
      rubygems = GemDating::Rubygems.new
      result = rubygems.fetch(specs.keys, nil)
      assert_equal 2, result.size
      assert_equal ["foo", "bar"].sort, result.map(&:name).sort
    end
  end

  def test_fetch_filters_gems_older_than_cutoff
    today = Date.today

    recent_gem = build_mock_spec(name: "recent", version: "1.0", date: today - 10)
    old_gem = build_mock_spec(name: "old", version: "1.0", date: today - 400)

    specs = { "recent" => recent_gem, "old" => old_gem }

    Gem.stub :latest_spec_for, ->(name) { specs[name] } do
      rubygems = GemDating::Rubygems.new
      result = rubygems.fetch(specs.keys, "1y")
      assert_includes result.map(&:name), "old"
      refute_includes result.map(&:name), "recent"
    end
  end

  def test_cut_off_parsing_years
    rubygems = GemDating::Rubygems.new
    cutoff = rubygems.send(:cut_off, "2y")
    expected = Date.today << 24
    assert_equal expected, cutoff
  end

  def test_cut_off_parsing_months
    rubygems = GemDating::Rubygems.new
    cutoff = rubygems.send(:cut_off, "3m")
    expected = Date.today << 3
    assert_equal expected, cutoff
  end

  def test_cut_off_parsing_weeks
    rubygems = GemDating::Rubygems.new
    cutoff = rubygems.send(:cut_off, "4w")
    expected = Date.today - 28
    assert_equal expected, cutoff
  end

  def test_cut_off_parsing_days
    rubygems = GemDating::Rubygems.new
    cutoff = rubygems.send(:cut_off, "10d")
    expected = Date.today - 10
    assert_equal expected, cutoff
  end

  def test_cut_off_invalid_format_raises
    rubygems = GemDating::Rubygems.new
    assert_raises(ArgumentError) { rubygems.send(:cut_off, "5x") }
    assert_raises(ArgumentError) { rubygems.send(:cut_off, "abc") }
    assert_raises(ArgumentError) { rubygems.send(:cut_off, "") }
  end

  def test_unknown_version_returns_spec_with_defaults
    rubygems = GemDating::Rubygems.new
    spec = rubygems.unknown_version("foobar")
    assert_equal "foobar", spec.name
    assert_equal Gem::Version.new("0.0.0.UNKNOWN"), spec.version
    assert_equal Date.parse("1970-01-01"), spec.date.to_date
  end
end
