require 'sequencescape-api/resource'

class Sequencescape::Well < ::Sequencescape::Api::Resource
  belongs_to :plate

  attribute_accessor :location
end
