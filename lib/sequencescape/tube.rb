require 'sequencescape/asset'
require 'sequencescape/behaviour/receptacle'
require 'sequencescape/behaviour/barcoded'
require 'sequencescape/behaviour/labeled'

class Sequencescape::Tube < ::Sequencescape::Asset
  include Sequencescape::Behaviour::Receptacle
  include Sequencescape::Behaviour::Barcoded
  include Sequencescape::Behaviour::Labeled

  attribute_accessor :closed
  attribute_accessor :concentration, :volume
  attribute_accessor :scanned_in_date, :conversion => :to_time

  belongs_to :purpose, :class_name => 'TubePurpose'
  belongs_to :stock_plate, :class_name => 'Plate'
end
