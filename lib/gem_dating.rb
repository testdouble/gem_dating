require "gem_dating/version"
require_relative "gem_dating/input"
require_relative "gem_dating/rubygems"
require_relative "gem_dating/result"

module GemDating
  def self.from_string(s)
    gems = Input.string(s).gems
    specs = Rubygems.fetch(gems)
    Result.new(specs)
  end

  def self.from_file(path)
    gems = Input.file(path).gems
    specs = Rubygems.fetch(gems)
    Result.new(specs)
  end
end
