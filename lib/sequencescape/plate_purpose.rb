require 'sequencescape-api/resource'

class Sequencescape::PlatePurpose < ::Sequencescape::Api::Resource
  module PlateCreation
    def create!(attributes = nil)
      attributes ||= {}
      attributes[:wells].delete_if { |_,v| v.blank? } if attributes.key?(:wells)

      new({}, false).tap do |plate|
        api.create(actions.create, { 'plate' => attributes }, Sequencescape::Api::ModifyingHandler.new(plate))
      end
    end
  end

  has_many :children, :class_name => 'PlatePurpose'

  has_many :plates do
    include Sequencescape::PlatePurpose::PlateCreation
  end

  attribute_reader :name
end
