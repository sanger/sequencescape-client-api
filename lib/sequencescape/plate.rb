require 'sequencescape/asset'

class Sequencescape::Plate < ::Sequencescape::Asset
  require 'sequencescape/behaviour/barcoded'
  require 'sequencescape/behaviour/state_driven'
  require 'sequencescape/plate/well_structure'
  require 'sequencescape/plate/pooling'
  require 'sequencescape/plate/pre_cap_groups'

  include Sequencescape::Behaviour::Barcoded
  include Sequencescape::Behaviour::StateDriven
  include Sequencescape::Plate::WellStructure
  include Sequencescape::Plate::Pooling
  include Sequencescape::Plate::PreCapGroups

  has_many :wells

  belongs_to :plate_purpose
  composed_of :stock_plate, :class_name => 'Plate'

  has_many :source_transfers, :class_name => 'Transfer'
  has_many :transfers_to_tubes, :class_name => 'Transfer'
  belongs_to :creation_transfer, :class_name => 'Transfer'

  attribute_accessor :size, :iteration, :pools, :label_text, :pre_cap_groups
end
