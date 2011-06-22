# Anything that can have a barcode is considered to be barcoded!
module Sequencescape::Behaviour
  module Barcoded
    def self.included(base)
      base.class_eval do
        attribute_group :barcode do
          attribute_accessor :prefix, :number     # The pieces that make up a barcode
          attribute_accessor :ean13               # The EAN13 barcode number
          attribute_accessor :two_dimensional     # The 2D barcode
        end
      end
    end
  end
end
