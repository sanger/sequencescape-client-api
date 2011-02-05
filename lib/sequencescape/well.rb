require 'sequencescape-api/resource'

class Sequencescape::Well < ::Sequencescape::Api::Resource
  belongs_to :plate, :class_name => 'Sequencescape::Plate'
end
