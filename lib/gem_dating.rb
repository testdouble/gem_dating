require "gem_dating/version"
require_relative "gem_dating/input"
require_relative "gem_dating/rubygems"
require_relative "gem_dating/result"
require_relative "gem_dating/cli"

module GemDating
  def self.from_string(s, older_than=nil)
    gems = Input.string(s).gems
    specs = Rubygems.fetch(gems, older_than)
    Result.new(specs)
  end

  def self.from_file(path, older_than=nil)
    gems = Input.file(path).gems
    specs = Rubygems.fetch(gems, older_than)
    Result.new(specs)
  end
end
