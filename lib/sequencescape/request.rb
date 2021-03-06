require 'sequencescape-api/resource'

class Sequencescape::Request < ::Sequencescape::Api::Resource
  belongs_to :project
  belongs_to :study
  belongs_to :sample
  belongs_to :submission

  belongs_to :source_asset, class_name: 'Asset'
  belongs_to :target_asset, class_name: 'Asset'

  attribute_accessor :type, :state
  validates_inclusion_of :state, in: %w[pending started failed passed cancelled blocked hold]

  attribute_accessor :read_length, :library_type, :fragment_size
end
