class Sequencescape::LibraryEvent < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :seed, :class_name => 'Plate'
  attribute_accessor :event_type
end
