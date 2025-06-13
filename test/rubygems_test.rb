require "test_helper"
require "date"

class GemDating::RubygemsTest < Minitest::Test
  def test_unknown_version_returns_spec_with_defaults
    rubygems = GemDating::Rubygems.new
    spec = rubygems.unknown_version("foobar")
    assert_equal "foobar", spec.name
    assert_equal Gem::Version.new("0.0.0.UNKNOWN"), spec.version
    assert_equal Date.parse("1970-01-01"), spec.date.to_date
  end
end
