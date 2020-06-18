require 'sequencescape-api/resource'

class Sequencescape::AssetAudit < ::Sequencescape::Api::Resource
  belongs_to :asset

  attribute_accessor :message, :key, :created_by, :asset, :witnessed_by, :metadata
end
