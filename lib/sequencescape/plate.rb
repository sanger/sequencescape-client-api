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
  has_many :submission_pools

  belongs_to :plate_purpose
  composed_of :stock_plate, :class_name => 'Plate'

  module CommentsCreation
    def create!(attributes = nil)
      attributes ||= {}

      new({}, false).tap do |comment|
        api.create(actions.create, { 'comment' => attributes }, Sequencescape::Api::ModifyingHandler.new(comment))
      end
    end

  end

  module CurrentVolumeSubstraction
    def substract_volume!(substracted_volume_value)
      api.update(actions.update, { 'substract_volume' => substracted_volume_value }, Sequencescape::Api::ModifyingHandler.new(self))
    end

  end
  include CurrentVolumeSubstraction

  has_many :comments do
    include Sequencescape::Plate::CommentsCreation
  end

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
