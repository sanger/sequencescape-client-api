require 'sequencescape-api/resource'

class Sequencescape::Batch < ::Sequencescape::Api::Resource
  belongs_to :pipeline
  has_many   :requests, :disposition => :inline
end
