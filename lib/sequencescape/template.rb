require 'sequencescape-api/resource'
require 'sequencescape/tag'

class Sequencescape::Template < ::Sequencescape::Api::Resource
  attribute_reader :name
end
