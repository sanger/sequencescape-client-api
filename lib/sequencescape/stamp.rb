require 'sequencescape-api/resource'

class Sequencescape::Stamp < ::Sequencescape::Api::Resource

  belongs_to :user
  belongs_to :lot
  belongs_to :robot
  attribute_accessor :tip_lot, :stamp_details
end
