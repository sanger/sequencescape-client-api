require 'sequencescape/asset'

class Sequencescape::PlateTemplate < ::Sequencescape::Asset

  require 'sequencescape/plate/well_structure'

  include Sequencescape::Plate::WellStructure

  has_many :wells

  attribute_accessor :size, :name

end
