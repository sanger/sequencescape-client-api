require 'sequencescape-api/resource'

module Sequencescape
  class SampleTube < ::Sequencescape::Api::Resource
    has_many   :requests,      :class_name => 'Sequencescape::Request'
    has_many   :library_tubes, :class_name => 'Sequencescape::LibraryTube'
    belongs_to :sample,        :class_name => 'Sequencescape::Sample'
  end
end
