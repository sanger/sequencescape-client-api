require 'sequencescape-api/resource'

class Sequencescape::CreateSearch < ::Sequencescape::Api::Resource

  attribute_accessor :description
  attribute_accessor :model
  attribute_accessor :criteria

  attribute_accessor :result

  has_create_action

end

