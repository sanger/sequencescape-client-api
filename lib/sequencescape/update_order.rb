require 'sequencescape-api/resource'

class Sequencescape::UpdateOrder < ::Sequencescape::Api::Resource

  attribute_accessor :order_uuid
  attribute_accessor :items

  has_create_action

end

