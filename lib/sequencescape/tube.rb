require 'sequencescape/asset'
require 'sequencescape/behaviour/receptacle'
require 'sequencescape/behaviour/barcoded'
require 'sequencescape/behaviour/labeled'
require 'sequencescape/behaviour/qced'

class Sequencescape::Tube < ::Sequencescape::Asset
  include Sequencescape::Behaviour::Receptacle
  include Sequencescape::Behaviour::Barcoded
  include Sequencescape::Behaviour::Labeled
  include Sequencescape::Behaviour::Qced

  has_many :requests

  attribute_accessor :closed
  attribute_accessor :concentration, :volume
  attribute_accessor :scanned_in_date, :conversion => :to_time

  attribute_reader :state

  attribute_accessor :sibling_tubes

  belongs_to :purpose, :class_name => 'TubePurpose'
  belongs_to :stock_plate, :class_name => 'Plate'
  belongs_to :custom_metadatum_collection
end
