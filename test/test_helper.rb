$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "gem_dating"
require "minitest/autorun"
require "mocktail"

class Minitest::Test
  include Mocktail::DSL

  def teardown
    Mocktail.reset
  end
end
