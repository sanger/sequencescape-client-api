require 'sequencescape-api/resource'

class Sequencescape::Plate < ::Sequencescape::Api::Resource
  has_many :wells, :disposition => :inline
end
