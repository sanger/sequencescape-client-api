require 'sequencescape-api/resource'

class Sequencescape::Tag < ::Sequencescape::Api::Resource

  attribute_accessor :name, :oligo, :group

  # TODO fix identifier in Lims-api
  def identifier
    1
  end

  class Group
    include Sequencescape::Api::Composition::Target

    attribute_accessor :uuid
    attribute_accessor :name, :tags, :created_at, :updated_at
  end
end
