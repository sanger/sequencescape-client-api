require 'sequencescape-api/resource'

class Sequencescape::SampleTube < ::Sequencescape::Asset
  has_many   :requests
  has_many   :library_tubes
  belongs_to :sample
end
