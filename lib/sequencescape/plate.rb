require 'sequencescape/asset'
require 'sequencescape/behaviour/barcoded'

class Sequencescape::Plate < ::Sequencescape::Asset
  include Sequencescape::Behaviour::Barcoded

  has_many :wells, :disposition => :inline
  belongs_to :plate_purpose

  has_many :source_transfers, :class_name => 'Transfer'
  belongs_to :creation_transfer, :class_name => 'Transfer'

  attribute_accessor :size, :iteration, :state
end
