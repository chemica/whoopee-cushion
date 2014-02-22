# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whoopee_cushion/version'

Gem::Specification.new do |spec|
  spec.name          = "whoopee-cushion"
  spec.version       = WhoopeeCushion::VERSION
  spec.authors       = ["Ben Dunkley"]
  spec.email         = ["ben@chemica.co.uk"]
  spec.summary       = %q{Allow recursive inflation of JSON data into structs.}
  spec.description   = %q{Inflates JSON data recursively into structs to allow use of dot notation for data access.}
  spec.homepage      = "https://github.com/chemica/whoopee-cushion?source=c"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 4.7.3"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "recursive-open-struct"
end

