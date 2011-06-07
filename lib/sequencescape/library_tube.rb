require 'sequencescape-api/resource'
require 'sequencescape/receptacle'

class Sequencescape::LibraryTube < ::Sequencescape::Asset
  include Sequencescape::Receptacle

  has_many   :requests
  belongs_to :source_request, :class_name => 'Sequencescape::Request'

  attribute_accessor :closed
  attribute_accessor :concentration, :volume
  attribute_accessor :scanned_in_date, :conversion => :to_time
end
