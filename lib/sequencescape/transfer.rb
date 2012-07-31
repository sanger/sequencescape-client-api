require 'sequencescape-api/resource'

class Sequencescape::Transfer < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :source, :class_name => 'Asset', :disposition => :inline
  belongs_to :destination, :class_name => 'Asset', :disposition => :inline
  attribute_reader :transfers
  attribute_accessor :targets
end
