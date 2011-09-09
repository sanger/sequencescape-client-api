require 'sequencescape-api/resource'
require 'sequencescape/tag'

class Sequencescape::TagLayout < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :plate, :class_name => 'Plate'
  composed_of :tag_group, :class_name => 'Tag::Group'

  attr_reader :direction
  attr_accessor :substitutions
end
