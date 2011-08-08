class BaitLibrary
  include Sequencescape::Api::Composition::Target

  attribute_accessor :name
  attribute_accessor :created_at, :updated_at, :conversion => :to_time

  attribute_group :supplier do
    attribute_accessor :name, :identifier
  end

  attribute_group :target do
    attribute_accessor :species
  end
end
