require 'sequencescape-api/resource'

class Sequencescape::Study < ::Sequencescape::Api::Resource
  has_many :projects,     :class_name => 'Sequencescape::Project'
  has_many :asset_groups, :class_name => 'Sequencescape::AssetGroup'
  has_many :samples,      :class_name => 'Sequencescape::Sample'
end
