require 'sequencescape-api/resource'

class Sequencescape::CustomMetadatumCollection < Sequencescape::Api::Resource
  belongs_to :asset
  belongs_to :user

  attribute_accessor :metadata
end
