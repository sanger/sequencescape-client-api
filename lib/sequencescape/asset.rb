require 'sequencescape-api/resource'

class Sequencescape::Asset < ::Sequencescape::Api::Resource
  delegate_to_attributes :barcode, :name
end
