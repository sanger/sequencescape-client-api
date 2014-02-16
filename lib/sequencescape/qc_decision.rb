require 'sequencescape-api/resource'

class Sequencescape::QcDecision < ::Sequencescape::Api::Resource

  belongs_to :user
  belongs_to :lot

  attribute_accessor :decisions
end
