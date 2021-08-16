require 'sequencescape-api/resource'

class Sequencescape::SpecificTubeCreation < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :parent, class_name: 'Plate'
  has_many :parents, class_name: 'Asset'
  attribute_writer :child_purposes, :tube_attributes
  has_many :children, class_name: 'Tube'
end
