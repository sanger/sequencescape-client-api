require 'sequencescape-api/resource'

class Sequencescape::TubeFromTubeCreation < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :parent, class_name: 'Plate'
  belongs_to :child_purpose, class_name: 'TubePurpose'
  belongs_to :child, class_name: 'Tube'
end
