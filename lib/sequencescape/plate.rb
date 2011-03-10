require 'sequencescape-api/resource'

class Sequencescape::Plate < ::Sequencescape::Asset
  has_many :wells, :disposition => :inline

  attribute_accessor :size
end
