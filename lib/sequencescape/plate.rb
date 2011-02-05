require 'sequencescape-api/resource'

class Sequencescape::Plate < ::Sequencescape::Api::Resource
  has_many :wells, :class_name => 'Sequencescape::Well', :disposition => :inline
end
