class Sequencescape::Tag
  include Sequencescape::Api::Composition::Target

  attribute_accessor :name, :oligo, :group, :identifier

  class Group
    include Sequencescape::Api::Composition::Target

    attr_accessor :actions

    attribute_accessor :uuid
    attribute_accessor :name, :tags, :created_at, :updated_at
  end
end
