require 'sequencescape-api/resource'

class Sequencescape::TransferRequest < ::Sequencescape::Api::Resource

  belongs_to :source_asset, :class_name => 'Asset'
  belongs_to :target_asset, :class_name => 'Asset'

  attribute_accessor :type, :state

end
