require 'sequencescape-api/resource'
require 'sequencescape/tag'

class Sequencescape::TagLayout < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :plate, :class_name => 'Plate'
  composed_of :tag_group, :class_name => 'Tag::Group'
  composed_of :tag2_group, :class_name => 'Tag::Group'

  attribute_accessor :substitutions, :direction, :walking_by, :initial_tag, :tags_per_well
end
