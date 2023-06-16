
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gem_dating/version"

Gem::Specification.new do |spec|
  spec.name          = "gem_dating"
  spec.version       = GemDating::VERSION
  spec.authors       = ["Steve Jackson"]
  spec.email         = ["steve@testdouble.com"]

  spec.summary       = "How old is that anyway?"
  spec.homepage      = "https://github.com/testdouble/gem_dating"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler"
  spec.add_dependency "table_print"
  spec.add_dependency "ruby-limiter"
end
