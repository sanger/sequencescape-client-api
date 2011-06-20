require 'sequencescape-api/resource'

class Sequencescape::BaitLibraryLayout < ::Sequencescape::Api::Resource
  belongs_to :plate, :class_name => 'Plate'
  attribute_reader :layout

  has_class_create_action(:preview!, :action => :preview)
end
