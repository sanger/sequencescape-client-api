require 'sequencescape-api/resource'
require 'sequencescape/tag'

class Sequencescape::TagLayoutTemplate < ::Sequencescape::Api::Resource
  attribute_reader :name, :direction, :walking_by
  belongs_to :plate, :class_name => 'Plate'
  composed_of :tag_group, :class_name => 'Tag::Group'

  has_create_action :resource => 'tag_layout'
end
