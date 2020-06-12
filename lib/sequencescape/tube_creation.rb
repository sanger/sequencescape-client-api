require 'sequencescape-api/resource'

class Sequencescape::TubeCreation < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :parent, class_name: 'Plate'
  belongs_to :child_purpose, class_name: 'TubePurpose'
  has_many :children, class_name: 'Tube'
end
