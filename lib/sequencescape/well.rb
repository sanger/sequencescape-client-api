require 'sequencescape-api/resource'

module Sequencescape
  class Well < ::Sequencescape::Api::Resource
    belongs_to :plate, :class_name => 'Sequencescape::Plate'
  end
end
