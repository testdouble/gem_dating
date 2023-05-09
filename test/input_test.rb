require "test_helper"

class TestInput < Minitest::Test
  def test_just_gem_names
    gems = GemDating::Input.new("\nrails\nredis\n\n").gems
    assert_equal ["rails", "redis"], gems
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

    gems = GemDating::Input.new(pasteboard).gems
    assert_equal ["rails", "sprockets-rails", "sqlite3", "puma"], gems
  end

  def test_we_hate_spaces
    pasteboard = <<-TEXT
      gem "rails","~> 7.0.3",">= 7.0.3.1"

      gem "sqlite3"
    TEXT

    gems = GemDating::Input.new(pasteboard).gems
    assert_equal ["rails", "sqlite3"], gems
  end

  def test_parens_are_serious_business
    pasteboard = <<-TEXT
      gem("rails","~> 7.0.3",">= 7.0.3.1")

      gem(  "sqlite3",     "42.42.42.24" )
    TEXT

    gems = GemDating::Input.new(pasteboard).gems
    assert_equal ["rails", "sqlite3"], gems
  end
end
