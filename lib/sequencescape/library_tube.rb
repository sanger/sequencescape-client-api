require 'sequencescape/tube'

class Sequencescape::LibraryTube < ::Sequencescape::Tube
  has_many   :requests
  belongs_to :source_request, :class_name => 'Sequencescape::Request'
  belongs_to :custom_metadatum_collection
end
