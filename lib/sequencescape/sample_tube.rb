require 'sequencescape-api/resource'
require 'sequencescape/receptacle'

class Sequencescape::SampleTube < ::Sequencescape::Asset
  include Sequencescape::Receptacle

  has_many   :requests
  has_many   :library_tubes

  attribute_accessor :closed
  attribute_accessor :concentration, :volume
  attribute_accessor :scanned_in_date, :conversion => :to_time
end
