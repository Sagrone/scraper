# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sagrone_scraper/version'

Gem::Specification.new do |spec|
  spec.name          = "sagrone_scraper"
  spec.version       = SagroneScraper::VERSION
  spec.authors       = ["Marius Colacioiu"]
  spec.email         = ["marius.colacioiu@gmail.com"]
  spec.summary       = %q{Sagrone Ruby Scraper.}
  spec.description   = %q{Simple library to scrap web pages.}
  spec.homepage      = ""
  spec.license       = "Apache License 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mechanize", "~> 2.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
end
