require 'sequencescape/asset'
require 'sequencescape/behaviour/receptacle'
require 'sequencescape/behaviour/barcoded'

class Sequencescape::Tube < ::Sequencescape::Asset
  include Sequencescape::Behaviour::Receptacle
  include Sequencescape::Behaviour::Barcoded

  attribute_accessor :closed
  attribute_accessor :concentration, :volume, :label_text
  attribute_accessor :scanned_in_date, :conversion => :to_time

  belongs_to :purpose, :class_name => 'TubePurpose'
  belongs_to :stock_plate, :class_name => 'Plate'
end
