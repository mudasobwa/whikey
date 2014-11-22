# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whikey/version'

Gem::Specification.new do |spec|
  spec.name          = "whikey"
  spec.version       = Whikey::VERSION
  spec.authors       = ["Alexei Matyushkin"]
  spec.email         = ["am@mudasobwa.ru"]
  spec.summary       = %q{Wiki JSON API response parsing library.}
  spec.description   = %q{Library providing easy handling of wikipedia json.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'yard-cucumber'
end
