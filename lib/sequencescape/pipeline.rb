require 'sequencescape-api/resource'

class Sequencescape::Pipeline < ::Sequencescape::Api::Resource
  attribute_accessor :name

  has_many :requests
  has_many :batches do
    has_create_action
  end
end
