
require 'sequencescape-api/resource'

class Sequencescape::Qcable < ::Sequencescape::Api::Resource

  belongs_to :lot
  belongs_to :qcable_creator
  belongs_to :asset

  attribute_accessor :state, :stamp_bed, :stamp_index

  attribute_group :barcode do
    attribute_accessor :prefix, :number     # The pieces that make up a barcode
    attribute_accessor :ean13               # The EAN13 barcode number
    attribute_accessor :machine             # The barcode printed on the label
  end

end
