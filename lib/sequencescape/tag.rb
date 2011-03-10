class Sequencescape::Tag
  include Sequencescape::Api::Composition::Target

  attribute_accessor :uuid, :exepcted_sequencescape
  composed_of :group, :class_name => 'Sequencescape::Tag::Group'

  class Group
    include Sequencescape::Api::Composition::Target

    attribute_accessor :uuid, :name
  end
end
