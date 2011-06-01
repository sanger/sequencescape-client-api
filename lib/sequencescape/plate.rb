require 'sequencescape-api/resource'

class Sequencescape::Plate < ::Sequencescape::Asset
  has_many :wells, :disposition => :inline
  belongs_to :plate_purpose

  attribute_accessor :size
end
