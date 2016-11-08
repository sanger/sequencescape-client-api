require 'sequencescape/library_tube'

class Sequencescape::MultiplexedLibraryTube < Sequencescape::LibraryTube
  attribute_reader :state
  belongs_to :custom_metadatum_collection
end
