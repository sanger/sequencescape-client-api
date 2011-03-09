require 'sequencescape-api/resource'

class Sequencescape::SampleTube < ::Sequencescape::Asset
  has_many   :requests
  has_many   :library_tubes
  belongs_to :sample

  attribute_accessor :closed
  attribute_accessor :concentration, :volume
  attribute_accessor :scanned_in_date, :conversion => :to_time
end
