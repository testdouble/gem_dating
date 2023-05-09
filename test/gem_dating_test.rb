require "test_helper"

class GemDatingTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::GemDating::VERSION
  end

  def test_single_gem
    result, _rest = GemDating.from_string("rest-client").to_a
    assert_equal "rest-client", result.name
    assert_operator Gem::Version.new("2.1.0"), :<=, result.version
    assert_operator Date.parse("2019-08-21"), :<=, result.date.to_date
  end

  def test_gems_copy_pasted_from_gemfile
    pasteboard = <<-'TEXT'
      source "https://rubygems.org"
      git_source(:github) { |repo| "https://github.com/#{repo}.git" }

      ruby "3.1.0"

      # Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
      gem "rails", "~> 7.0.3", ">= 7.0.3.1"

      # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
      gem "sprockets-rails"

      # Use sqlite3 as the database for Active Record
      gem "sqlite3", "~> 1.4"

      # Use the Puma web server [https://github.com/puma/puma]
      gem "puma", "~> 5.0"
    TEXT

    rails, _rest = GemDating.from_string(pasteboard).to_a

    assert_equal "rails", rails.name
    assert_operator Gem::Version.new("7.0"), :<=, rails.version
    assert_operator Date.parse("2023-03-13"), :<=, rails.date.to_date
  end

  def test_gems_from_gemfile
    result = GemDating.from_file("test/Gemfile.example").to_h

    assert_equal "rest-client", result["rest-client"]["name"]
    assert_operator Gem::Version.new("2.1.0"), :<=, result["rest-client"]["version"]
    assert_operator Date.parse("2019-08-21"), :<=, Date.parse(result["rest-client"]["date"])
  end
end
