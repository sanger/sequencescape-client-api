require 'sequencescape-api/resource'

class Sequencescape::TagWells < ::Sequencescape::Api::Resource

  attribute_accessor :plate_uuid
  attribute_accessor :well_to_tag_map

  has_create_action
end

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular("tag_wells", "tag_wells")
end
