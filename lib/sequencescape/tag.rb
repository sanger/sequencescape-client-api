class Sequencescape::Tag
  include Sequencescape::Api::Composition::Target

  attribute_accessor :name, :oligo, :group, :identifier

  class Group
    include Sequencescape::Api::Composition::Target

    attribute_accessor :name, :tags
  end
end
