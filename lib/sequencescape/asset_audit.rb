require 'sequencescape-api/resource'

class Sequencescape::AssetAudit < ::Sequencescape::Api::Resource
  belongs_to :asset
end
