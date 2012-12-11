require 'sequencescape/asset'
require 'sequencescape/transfer'

class Sequencescape::Plate < ::Sequencescape::Asset
  require 'sequencescape/behaviour/barcoded'
  require 'sequencescape/behaviour/state_driven'
  require 'sequencescape/plate/well_structure'
  require 'sequencescape/plate/pooling'

  include Sequencescape::Behaviour::Barcoded
  include Sequencescape::Behaviour::StateDriven
  include Sequencescape::Plate::WellStructure
  include Sequencescape::Plate::Pooling
  include Sequencescape::Api::Resource::Attributes::SizeCalculator

  has_many :wells, :disposition => :receptacle_inline

  belongs_to :plate_purpose
  composed_of :stock_plate, :class_name => 'Plate'

  has_many :source_transfers, :class_name => 'Transfer'
  has_many :transfers_to_tubes, :class_name => 'Transfer'
  belongs_to :creation_transfer, :class_name => 'Transfer'

  attribute_accessor :iteration, :pools

  def child
    self
  end

  def tubes
    order = api.order.find(Settings.temp["Order uuid"])
    tube_uuid = order.items["MX tube"]["uuid"]

    #[OpenStruct.new(:uuid => tube_uuid)]
    [api.tube.find(tube_uuid)]
  end
end

class Sequencescape::Plate::CreationTransferBelongsToProxy
  def transfers
    order = api.order.find(Settings.temp["Order uuid"])
    Hash[order.parameters["sequencing_pool"].map { |well| [well, "A1"] }]
  end
end

module ::Pulldown
  class PooledPlate < Sequencescape::Plate
    def tubes
      super
    end

    # We need to specialise the transfers where this plate is a source so that it handles
    # the correct types
    class Transfer < ::Sequencescape::Transfer
      belongs_to :source, :class_name => 'PooledPlate', :disposition => :inline
      attribute_reader :transfers

      def transfers_with_tube_mapping=(transfers)
        send(
          :transfers_without_tube_mapping=, Hash[
            transfers.map do |well, tube_json|
              [ well, ::Pulldown::MultiplexedLibraryTube.new(api, tube_json, false) ]
            end
          ]
        )
      end
      alias_method_chain(:transfers=, :tube_mapping)
    end

    has_many :transfers_to_tubes, :class_name => 'PooledPlate::Transfer'

    def well_to_tube_transfers
      {"A1" => tubes.first} 
    end

    # We know that if there are any transfers with this plate as a source then they are into
    # tubes.
    def has_transfers_to_tubes?
      not well_to_tube_transfers.empty?
    end

    # Well locations ordered by columns.
    WELLS_IN_COLUMN_MAJOR_ORDER = (1..12).inject([]) { |a,c| a.concat(('A'..'H').map { |r| "#{r}#{c}" }) ; a }

    # Returns the tubes that an instance of this plate has been transferred into.
#      def tubes
#        debugger
#        return [] unless has_transfers_to_tubes?
#        WELLS_IN_COLUMN_MAJOR_ORDER.map(&well_to_tube_transfers.method(:[])).compact
#      end

    def tubes_and_sources
      return [] unless has_transfers_to_tubes?
      WELLS_IN_COLUMN_MAJOR_ORDER.map do |l|
        [l, well_to_tube_transfers[l]]
      end.group_by do |_, t|
        t && t.uuid
      end.reject do |uuid, _|
        uuid.nil?
      end.map do |_, well_tube_pairs|
        [well_tube_pairs.first.last, well_tube_pairs.map(&:first)]
      end
    end
  end
end

#module Pulldown
#  class Plate
#    def coerce
#      self
#    endc
#  end
#end
#    def new(api, json, success)
#      debugger
#      @api, @owner, @success = api, owner, success
#    end
#
#    class TransfersToTubesHasManyProxy
#      def first
#        self
#      end
#
#      def transfers
#        debugger
#        order = api.order.find(Settings.temp["Order uuid"])
#          Hash["A1" => order.targets["MX tube"]]
#      end
#    end
#  end
#end
