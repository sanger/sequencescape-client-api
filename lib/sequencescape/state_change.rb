require 'sequencescape-api/resource'

class Sequencescape::StateChange < ::Sequencescape::Api::Resource
  belongs_to :target, :class_name => 'Asset'
  attribute_accessor :contents          # Array of "contents" to fail, deciphered by the target, can be nil
  attribute_accessor :target_state
  attribute_accessor :previous_state
end
