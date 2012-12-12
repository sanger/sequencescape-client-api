require 'sequencescape-api/resource'
require 'sequencescape-api/resource_model_proxy'
require 'sequencescape/tag'

class Sequencescape::TagLayoutTemplate < ::Sequencescape::Api::Resource
  attribute_reader :name, :direction, :walking_by
  attribute_reader :tags
  belongs_to :plate, :class_name => 'Plate'
  composed_of :tag_group, :class_name => 'Tag::Group'

  has_create_action :resource => 'tag_layout'

  def tag_group
    self
  end
end

module Lims::Api
  class TagWells
    def initialize(api)
      @api = api
    end

    def find(tag_layout_template_uuid)
      self
    end

    def wells_to_tag_map(plate_uuid)
     wells =  @api.plate.find(plate_uuid).wells.map {|well| well.location unless well.aliquots.empty?}.compact
     oligos = @api.oligo.all.map { |oligo| oligo.uuid}
     Hash[wells.zip(oligos)]
    end

    def create!(attributes)
      @api.tag_wells.create!({
        :plate_uuid => attributes[:plate],
        :well_to_tag_map => wells_to_tag_map(attributes[:plate]) 
      })
    end

    # Might need to deal with args in some way
    def method_missing(name, *args, &block)
      eval "@api.original_tag_layout_template.#{name.to_s}"
    end
  end
end
