require 'sequencescape-api/resource'

class Sequencescape::Order < ::Sequencescape::Api::Resource
  has_many :assets
  belongs_to :user
  belongs_to :study
  belongs_to :project

  # It does, but we don't care for now.
  # has_many :request_types

  attr_accessor :request_options
end
