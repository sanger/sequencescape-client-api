require 'sequencescape-api/resource'

class Sequencescape::Submission < ::Sequencescape::Api::Resource
  belongs_to :user
  # TODO: get this working
  # has_many   :requests

  # TODO: use a has many, but ensure it works
  attribute_accessor :orders

  has_update_action :submit!, action: 'submit', verb: :create, skip_json: true

  attribute_reader :state
  attribute_reader :asset_group_name
end
