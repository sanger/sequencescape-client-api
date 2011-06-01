require 'sequencescape-api/resource'

class Sequencescape::Transfer < ::Sequencescape::Api::Resource
  belongs_to :source, :class_name => 'Asset'
  belongs_to :destination, :class_name => 'Asset'
  attribute_accessor :transfers
end
