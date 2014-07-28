require 'sequencescape-api/resource'

class Sequencescape::Robot < ::Sequencescape::Api::Resource
  attribute_accessor :name, :robot_properties
end
