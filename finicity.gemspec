# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'finicity/version'

Gem::Specification.new do |spec|
  spec.name          = "finicity"
  spec.version       = Finicity::VERSION
  spec.authors       = ["Moneydesktop"]
  spec.email         = ["dev@moneydesktop.com"]
  spec.summary       = %q{A gem to communicate easily with Finicity's API}
  spec.description   = %q{A gem to communicate easily with Finicity's API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'httpclient', '>= 2.4.0'
  spec.add_dependency 'nokogiri', '>= 1.6.0' # needed so that sax-machine knows which xml parser to use
  spec.add_dependency 'saxomattic', '>= 0.0.3'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '>= 3.1.0'
  spec.add_development_dependency 'simplecov'
end
