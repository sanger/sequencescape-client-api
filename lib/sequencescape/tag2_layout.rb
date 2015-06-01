require 'sequencescape-api/resource'
require 'sequencescape/tag'

class Sequencescape::Tag2Layout < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :plate, :class_name => 'Plate'
  composed_of :tag, :class_name => 'Tag'
end
