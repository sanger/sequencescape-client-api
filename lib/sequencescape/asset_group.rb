require 'sequencescape-api/resource'

class Sequencescape::AssetGroup < ::Sequencescape::Api::Resource
  belongs_to :submission
  belongs_to :study
  has_many   :assets

  attribute_accessor :name
end
