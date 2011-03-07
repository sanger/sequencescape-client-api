require 'sequencescape-api/resource'

class Sequencescape::Sample < ::Sequencescape::Api::Resource
  has_many :sample_tubes

  attribute_accessor :name
end
