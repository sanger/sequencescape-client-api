require 'sequencescape-api/resource'

class Sequencescape::BulkTransfer < ::Sequencescape::Api::Resource
  belongs_to :user
  has_many :transfers, class_name: 'Transfer'

  attribute_accessor :well_transfers
end
