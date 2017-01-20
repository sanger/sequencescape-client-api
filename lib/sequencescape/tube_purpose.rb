require 'sequencescape-api/resource'

class Sequencescape::TubePurpose < ::Sequencescape::Api::Resource
  module TubeCreation
    def create!(attributes = nil)
      attributes ||= {}
      attributes[:wells].delete_if { |_,v| v.blank? } if attributes.key?(:wells)

      new({}, false).tap do |plate|
        api.create(actions.create, { 'plate' => attributes }, Sequencescape::Api::ModifyingHandler.new(plate))
      end
    end
  end

  has_many :children, :class_name => 'TubePurpose'
  has_many :parents, :class_name => 'TubePurpose'

  has_many :tubes do
    include Sequencescape::TubePurpose::TubeCreation
  end

  attribute_reader :name
  attribute_writer :target_type, :type
end
