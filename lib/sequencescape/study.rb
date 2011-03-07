require 'sequencescape-api/resource'

class Sequencescape::Study < ::Sequencescape::Api::Resource
  has_many :projects
  has_many :asset_groups
  has_many :samples

  attribute_accessor :name
end
