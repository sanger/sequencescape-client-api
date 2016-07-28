require 'sequencescape-api/resource'
require 'sequencescape/tag'

class Sequencescape::Tag2Layout < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :plate, :class_name => 'Plate'
  belongs_to :source, :class_name => 'Asset'
  composed_of :tag, :class_name => 'Tag'
  attribute_reader :target_well_locations
end
