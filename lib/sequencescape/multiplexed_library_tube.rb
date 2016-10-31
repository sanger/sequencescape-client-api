require 'sequencescape/library_tube'

class Sequencescape::MultiplexedLibraryTube < Sequencescape::LibraryTube
  attribute_reader :state
  belongs_to :process_metadatum_collection
end
