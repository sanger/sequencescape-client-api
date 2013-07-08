require 'sequencescape-api/resource'
require 'sequencescape/asset'

class Sequencescape::BarcodedAsset < ::Sequencescape::Asset
  require 'sequencescape/behaviour/barcoded'
  require 'sequencescape/behaviour/qced'
  # Used in transfer to make barcodes easily retrieveable
  include Sequencescape::Behaviour::Barcoded
  include Sequencescape::Behaviour::Qced

  belongs_to :stock_plate, :class_name => 'Plate'
end
