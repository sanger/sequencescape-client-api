require 'sequencescape/asset'
require 'sequencescape/behaviour/barcoded'
require 'sequencescape/behaviour/state_driven'

class Sequencescape::Plate < ::Sequencescape::Asset
  include Sequencescape::Behaviour::Barcoded
  include Sequencescape::Behaviour::StateDriven

  has_many :wells, :disposition => :inline
  belongs_to :plate_purpose
  composed_of :stock_plate, :class_name => 'Plate'

  has_many :source_transfers, :class_name => 'Transfer'
  belongs_to :creation_transfer, :class_name => 'Transfer'

  attribute_accessor :size, :iteration
end
