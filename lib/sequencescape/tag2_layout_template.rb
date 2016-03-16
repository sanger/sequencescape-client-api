require 'sequencescape-api/resource'
require 'sequencescape/tag'

class Sequencescape::Tag2LayoutTemplate < ::Sequencescape::Api::Resource
  attribute_reader :name
  composed_of :tag, :class_name => 'Tag'

  has_create_action :resource => 'tag2_layout'
end
