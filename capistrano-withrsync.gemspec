# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/withrsync/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-withrsync"
  spec.version       = Capistrano::Withrsync::VERSION
  spec.authors       = ["linyows"]
  spec.email         = ["linyows@gmail.com"]
  spec.summary       = %q{Capistrano with rsync}
  spec.description   = %q{Capistrano with rsync}
  spec.homepage      = "https://github.com/linyows/capistrano-withrsync"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", ">= 3.1", '<3.7'

  spec.add_development_dependency "bundler", "> 1.3"
  spec.add_development_dependency "rake"
end
