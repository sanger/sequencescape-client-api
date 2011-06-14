require 'sequencescape-api/resource'
require 'sequencescape/tag'

class Sequencescape::TagLayout < ::Sequencescape::Api::Resource
  belongs_to :target, :class_name => 'Plate'
  composed_of :tag_group, :class_name => 'Tag::Group'
end