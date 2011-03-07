require 'sequencescape-api/resource'

class Sequencescape::Request < ::Sequencescape::Api::Resource
  belongs_to :project
  belongs_to :study
  belongs_to :sample
  belongs_to :submission

  belongs_to :source_asset, :class_name => 'Sequencescape::Asset'
  belongs_to :target_asset, :class_name => 'Sequencescape::Asset'

  attribute_accessor :state
end
