require 'sequencescape-api/resource'

class Sequencescape::Asset < ::Sequencescape::Api::Resource
  attribute_accessor :barcode, :name
end
