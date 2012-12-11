require 'sequencescape-api/resource'

class Sequencescape::Order < ::Sequencescape::Api::Resource

  attribute_accessor :state
  attribute_accessor :parameters
  attribute_accessor :items

  has_create_action

end

