require 'sequencescape-api/resource'

class Sequencescape::Sample < ::Sequencescape::Api::Resource
  has_many :sample_tubes, :class_name => 'Sequencescape::SampleTube'
end
