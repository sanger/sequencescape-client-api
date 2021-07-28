$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'sequencescape-api/version'

Gem::Specification.new do |s|
  s.name        = 'sequencescape-client-api'
  s.version     = Sequencescape::Api::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Matthew Denner', 'James Glover', 'Eduardo Martin Rojo']
  s.email       = ['md12@sanger.ac.uk', 'james.glover@sanger.ac.uk', 'emr@sanger.ac.uk']
  s.homepage    = ''
  s.summary     = 'Gem for the client side of the Sequencescape API'
  s.description = 'Provides all of the necessary code for interacting with the Sequencescape API'
  s.required_ruby_version = '> 2.4'

  s.rubyforge_project = 'sequencescape-client-api'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.post_install_message = <<~POST_INSTALL
    sequencescape-client-api has dropped 'yajl-ruby' in favour of 'multi_json',
    https://rubygems.org/gems/multi_json. This will automatically pick the
    fastest json encoder in your Gemfile, falling back to the default encoder.

    For best performance you are strongly encouraged to add a custom json
    encoder to your project. eg. bundle install oj.
  POST_INSTALL

  s.add_dependency('activemodel', '>= 5.0.0')
  s.add_dependency('activesupport', '>= 5.0.0')
  s.add_dependency('i18n')
  s.add_dependency('multi_json')

  s.add_development_dependency('pry')
  s.add_development_dependency('rake')
  s.add_development_dependency('redcarpet')
  s.add_development_dependency('rspec', '~> 2.11.0')
  s.add_development_dependency('rubocop', '~> 1.3.1')
  s.add_development_dependency('webmock')
  s.add_development_dependency('yard')
  # Add a json encoder for development
  s.add_development_dependency('oj')
end
