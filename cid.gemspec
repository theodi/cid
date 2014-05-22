# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cid/version'

Gem::Specification.new do |spec|
  spec.name          = "cid"
  spec.version       = Cid::VERSION
  spec.authors       = ["pezholio"]
  spec.email         = ["pezholio@gmail.com"]
  spec.summary       = "Tools to allow continuous integration when collaborating on data in Github"
  spec.homepage      = "http://github.com/theodi/datapackage.rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   << 'cid'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "csvlint"
  spec.add_dependency "colorize"
  spec.add_dependency "json"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "spork"

end
