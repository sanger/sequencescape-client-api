require 'sequencescape-api/resource'

class Sequencescape::Submission < ::Sequencescape::Api::Resource
  belongs_to :project
  belongs_to :study
  has_many   :requests

  has_update_action :submit!, :action => 'submit', :verb => :create
end
