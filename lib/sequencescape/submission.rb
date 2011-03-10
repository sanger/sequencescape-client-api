require 'sequencescape-api/resource'

class Sequencescape::Submission < ::Sequencescape::Api::Resource
  belongs_to :project
  belongs_to :study
  has_many   :requests

  has_update_action :submit!, :action => 'submit', :verb => :create

  attribute_accessor :state
  attribute_accessor :asset_group_name
  attribute_accessor :assets
  attribute_accessor :request_types
  attribute_accessor :request_options
end
