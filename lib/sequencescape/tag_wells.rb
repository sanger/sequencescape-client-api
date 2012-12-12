require 'sequencescape-api/resource'

class Sequencescape::TagWell < ::Sequencescape::Api::Resource

  attribute_accessor :plate_uuid
  attribute_accessor :well_to_tag_map

  has_create_action
end

