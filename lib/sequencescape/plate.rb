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
  belongs_to :custom_metadatum_collection

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
    def create!(attributes = nil)
      attributes ||= {}

      new({}, false).tap do |volume_update|
        api.create(actions.create, { 'volume_update' => attributes }, Sequencescape::Api::ModifyingHandler.new(volume_update))
      end
    end

    def substract_volume!(volume_change)
      create!({ :volume_change => volume_change})
    end
  end
  has_many :volume_updates do
    include Sequencescape::Plate::CurrentVolumeSubstraction
  end

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

  module UpdateExtractionAttributes
    def create!(attributes = nil)
      attributes ||= {}
      new({}, false).tap do |attrs|
        api.create(actions.create, {:extraction_attribute => attributes}, Sequencescape::Api::ModifyingHandler.new(attrs))
      end
    end
  end

  has_many :extraction_attributes, :class_name => 'ExtractionAttribute' do
    include Sequencescape::Plate::UpdateExtractionAttributes
  end

end
