
require 'sequencescape-api/resource'

class Sequencescape::Qcable < ::Sequencescape::Api::Resource

  belongs_to :lot
  belongs_to :qcable_creator
  belongs_to :asset

  attribute_accessor :asset_barcode, :state


end
