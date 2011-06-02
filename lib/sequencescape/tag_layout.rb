require 'sequencescape-api/resource'

class Sequencescape::TagLayout < ::Sequencescape::Api::Resource
  belongs_to :target, :class_name => 'Plate'
  belongs_to :tag_group
end
