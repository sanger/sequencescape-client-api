require 'sequencescape-api/resource'

class Sequencescape::PlateTransfer < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :source_uuid, :class_name => 'Asset', :disposition => :inline
  belongs_to :target_uuid, :class_name => 'Asset', :disposition => :inline
  attribute_reader :transfers
  attribute_accessor :transfer_map
  
  #TODO ke4 Remove the '_uuid' ending
  alias_method :source, :source_uuid
  alias_method :source=, :source_uuid=
  alias_method :destination, :target_uuid
  alias_method :destination=, :target_uuid=
  alias_method :targets, :transfer_map
  alias_method :targets=, :transfer_map=
end
