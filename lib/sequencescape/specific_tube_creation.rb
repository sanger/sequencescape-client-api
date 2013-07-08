require 'sequencescape-api/resource'

class Sequencescape::SpecificTubeCreation < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :parent, :class_name => 'Plate'
  attribute_writer :child_purposes #, :class_name => 'TubePurpose'
  has_many :children, :class_name => 'Tube'
end
