require 'sequencescape-api/resource'

class Sequencescape::ExtractionAttribute < ::Sequencescape::Api::Resource
  belongs_to :plate, :class_name => 'Asset', :disposition => :inline
  attribute_accessor :attributes_update, :created_by
end
