require 'sequencescape/asset'

class Sequencescape::Plate < ::Sequencescape::Asset
  require 'sequencescape/behaviour/barcoded'
  require 'sequencescape/behaviour/state_driven'
  require 'sequencescape/plate/well_structure'
  require 'sequencescape/plate/pooling'
  require 'sequencescape/behaviour/labeled'
  require 'sequencescape/behaviour/qced'

  include Sequencescape::Behaviour::Barcoded
  include Sequencescape::Behaviour::StateDriven
  include Sequencescape::Plate::WellStructure
  include Sequencescape::Plate::Pooling
  include Sequencescape::Behaviour::Labeled
  include Sequencescape::Behaviour::Qced

  has_many :wells

  belongs_to :plate_purpose
  composed_of :stock_plate, :class_name => 'Plate'

  has_many :comments

  has_many :source_transfers, :class_name => 'Transfer'
  has_many :transfers_to_tubes, :class_name => 'Transfer'
  has_many :creation_transfers, :class_name => 'Transfer'

  attribute_accessor :size, :iteration, :pools, :pre_cap_groups, :location, :priority

  # Provides backwards compatability
  def creation_transfer
    Rails.logger.warn "Creation transfer is deprecated, use creation_transfers instead"
    return creation_transfers.first if creation_transfers.count == 1
    raise Sequencescape::Api::Error, "Unexpected number of transfers found: #{creation_transfers.count} found, 1 expected."
  end

end
