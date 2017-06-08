require 'sequencescape-api/resource'

class Sequencescape::TransferRequestCollection < ::Sequencescape::Api::Resource
  belongs_to :user
  has_many :transfer_requests, disposition: :inline
  has_many :target_tubes, disposition: :inline, class_name: 'Tube'
end
