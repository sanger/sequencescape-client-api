require 'sequencescape-api'
require 'sequencescape'

# Make sure our support files can be loaded when required
$:.push(File.expand_path(File.join(File.dirname(__FILE__), 'support')))
require 'connection_support'

# Ensure that RSpec mocking is used
RSpec.configure do |config|
  config.mock_framework = :rspec
end

# Fake the web connections so we don't trash anything
require 'webmock/rspec'
