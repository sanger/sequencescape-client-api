require 'sequencescape-api/resource'

class Sequencescape::Batch < ::Sequencescape::Api::Resource
  belongs_to :pipeline, :class_name => 'Sequencescape::Pipeline'
  has_many   :requests, :class_name => 'Sequencescape::Request', :disposition => :inline
end
