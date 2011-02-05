require 'sequencescape-api/resource'

class Sequencescape::Submission < ::Sequencescape::Api::Resource
  belongs_to :project,  :class_name => 'Sequencescape::Project'
  belongs_to :study,    :class_name => 'Sequencescape::Study'
  has_many   :requests, :class_name => 'Sequencescape::Request'

  has_update_action :submit!, :action => 'submit', :verb => :create
end
