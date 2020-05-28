# frozen_string_literal: true

require 'sequencescape-api'
require 'sequencescape'

# Make sure our support files can be loaded when required
$:.push(File.expand_path(File.join(File.dirname(__FILE__), 'support')))
require 'contract_helper'
require 'namespaces'
require 'shared_examples'

# Ensure that RSpec mocking is used
RSpec.configure do |config|
  config.mock_framework = :rspec
end
