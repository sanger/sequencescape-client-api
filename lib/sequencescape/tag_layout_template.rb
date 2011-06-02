require 'sequencescape-api/resource'

class Sequencescape::TagLayoutTemplate < ::Sequencescape::Api::Resource
  attribute_reader :name
  belongs_to :target, :class_name => 'Plate'
  belongs_to :tag_group

  has_create_action :resource => 'tag_layout'
end
