require 'sequencescape-api/resource'
require 'sequencescape/tag'

class Sequencescape::LibraryTube < ::Sequencescape::Asset
  has_many   :requests
  belongs_to :sample
  belongs_to :source_request, :class_name => 'Sequencescape::Request'

  attribute_accessor :closed
  attribute_accessor :concentration, :volume
  attribute_accessor :scanned_in_date, :conversion => :to_time

  composed_of :tag
end
