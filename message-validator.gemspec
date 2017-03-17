# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'envelope/message-validator/version'

Gem::Specification.new do |spec|
  spec.name          = "message-validator"
  spec.version       = Envelope::MessageValidator::VERSION
  spec.authors       = ["Simon Pickartz"]
  spec.email         = ["spickartz@eonerc.rwth-aachen.de"]

  spec.summary       = %q{Validates YAML messages.}
  spec.description   = %q{The message-validator can be used for a validation of YAML messages in accordance with a given schameata.}
  spec.homepage      = "http://github.com/envelope-project/message-validator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "schemata"]

  spec.add_dependency "thor"
  spec.add_dependency "colorize"
  spec.add_dependency "kwalify"
  spec.add_dependency "mqtt"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
