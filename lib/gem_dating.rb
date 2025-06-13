require "gem_dating/version"
require_relative "gem_dating/input"
require_relative "gem_dating/rubygems"
require_relative "gem_dating/result"
require_relative "gem_dating/cli"

module GemDating
  def self.from_string(s, options = {})
    gems = Input.string(s).gems
    fetch_specs(gems, options)
  end

  def self.from_file(path, options = {})
    gems = Input.file(path).gems
    fetch_specs(gems, options)
  end


  def self.fetch_specs(gems, options)
    specs = Rubygems.fetch(gems)
    results = Result.new(specs)
    results.older_than(options[:older_than]) if options[:older_than]
    results
  end

  private_class_method :fetch_specs
end
