require 'sequencescape-api/resource'

class Sequencescape::Batch < ::Sequencescape::Api::Resource
  belongs_to  :pipeline
  has_many    :requests, :disposition => :inline
  composed_of :user

  has_update_action :complete!, :action => 'complete'
  has_update_action :release!, :action => 'release'
end
