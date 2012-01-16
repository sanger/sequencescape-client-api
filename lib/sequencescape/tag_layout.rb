require 'sequencescape-api/resource'
require 'sequencescape/tag'

class Sequencescape::TagLayout < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :plate, :class_name => 'Plate'
  composed_of :tag_group, :class_name => 'Tag::Group'

  attribute_reader :direction, :walking_by
  attribute_accessor :substitutions
end
