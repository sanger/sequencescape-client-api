require 'sequencescape-api/resource'

module Sequencescape
  class Sample < ::Sequencescape::Api::Resource
    has_many :sample_tubes, :class_name => 'Sequencescape::SampleTube'
  end
end
