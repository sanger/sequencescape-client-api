require 'sequencescape-api/resource'

class Sequencescape::TransferTemplate < ::Sequencescape::Api::Resource
  attribute_accessor :name
  attribute_accessor :transfers

  has_create_action :resource => 'transfer'
end
