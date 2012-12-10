require 'sequencescape-api/resource'

class Sequencescape::TransferWellsToTube < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :plate_uuid, :class_name => 'Asset', :disposition => :inline
  belongs_to :target_uuid, :class_name => 'Asset', :disposition => :inline
  attribute_reader :transfers
  attribute_accessor :well_to_tube_map
  
  has_create_action

  #TODO ke4 Remove the '_uuid' ending
  alias_method :source, :plate_uuid
  alias_method :source=, :plate_uuid=
  alias_method :destination, :target_uuid
  alias_method :destination=, :target_uuid=
  alias_method :targets, :well_to_tube_map
  alias_method :targets=, :well_to_tube_map=
end