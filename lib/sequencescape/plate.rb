require 'sequencescape-api/resource'

module Sequencescape
  class Plate < ::Sequencescape::Api::Resource
    has_many :wells, :class_name => 'Sequencescape::Well', :disposition => :inline
  end
end
