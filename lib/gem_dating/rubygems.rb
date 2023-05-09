require "bundler/setup"
require "ruby-limiter"

module GemDating
  class Rubygems
    extend Limiter::Mixin

    limit_method(:limited_fetch, rate: 600)

    def self.fetch(...)
      new.fetch(...)
    end

    attr_reader :source

    def initialize(source: nil)
      @source = source || init_source
    end

    def fetch(gems)
      gems.each { |gem| source.add_dependency_names(gem) }
      gems.map do |gem|
        latest = source.specs.search(gem).last
        if latest
          limited_fetch(latest)
        else
          Gem::Specification.new do |s|
            s.name = gem
            s.version = "0.0.0.UNKNOWN"
          end
        end
      end
    end

    def limited_fetch(gemspec)
      source.fetchers.first.fetch_spec([gemspec.name, gemspec.version, gemspec.platform])
    rescue
      Gem::Specification.new do |s|
        s.name = gemspec.name
        s.version = "0.0.0.UNKNOWN"
      end
    end

    def init_source
      source = ::Bundler::Source::Rubygems.new
      source.add_remote(::Gem.host)
      source.remote!
      source
    end
  end
end
