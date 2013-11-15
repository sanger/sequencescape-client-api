require 'sequencescape-api/resource'

class Sequencescape::StateChange < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :target, :class_name => 'Asset', :disposition => :inline
  attribute_accessor :contents          # Array of "contents" to fail, deciphered by the target, can be nil
  attribute_accessor :target_state
  attribute_accessor :previous_state
  attribute_accessor :reason
  attribute_accessor :customer_accepts_responsibility
end
