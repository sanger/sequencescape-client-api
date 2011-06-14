require 'sequencescape-api/resource'
require 'sequencescape/tag'

class Sequencescape::TagLayoutTemplate < ::Sequencescape::Api::Resource
  attribute_reader :name
  belongs_to :target, :class_name => 'Plate'
  composed_of :tag_group, :class_name => 'Tag::Group'

  has_create_action :resource => 'tag_layout'
end