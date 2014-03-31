# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exogenesis/version'

Gem::Specification.new do |spec|
  spec.name          = "exogenesis"
  spec.version       = Exogenesis::VERSION
  spec.authors       = ["moonglum"]
  spec.email         = ["moonglum@moonbeamlabs.com"]
  spec.description   = %q{Build your dotfile installer, updater and teardown}
  spec.summary       = %q{A collection of classes that help you install, update and teardown package managers and other things useful for your dotfiles.}
  spec.homepage      = "https://github.com/moonglum/exogenesis"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6.0"
  spec.add_development_dependency "rake", "~> 10.2.2"
  spec.add_development_dependency "rspec", "~> 3.0.0.beta2"
end
