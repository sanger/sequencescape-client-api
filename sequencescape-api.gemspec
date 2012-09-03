# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sequencescape-api/version"

Gem::Specification.new do |s|
  s.name        = "sequencescape-client-api"
  s.version     = Sequencescape::Api::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Matthew Denner"]
  s.email       = ["md12@sanger.ac.uk"]
  s.homepage    = ""
  s.summary     = %q{Gem for the client side of the Sequencescape API}
  s.description = %q{Provides all of the necessary code for interacting with the Sequencescape API}

  s.rubyforge_project = "sequencescape-client-api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('activesupport', '~> 3.0.0')
  s.add_dependency('activemodel', '~> 3.0.0')
  s.add_dependency('i18n')
  s.add_dependency('yajl-ruby', '~> 1.1.0')

  s.add_development_dependency('rspec', '~> 2.11.0')
  s.add_development_dependency('webmock')
end
