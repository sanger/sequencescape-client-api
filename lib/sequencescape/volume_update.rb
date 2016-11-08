require 'sequencescape-api/resource'

class Sequencescape::VolumeUpdate < ::Sequencescape::Api::Resource
  belongs_to :target, :class_name => 'Asset', :disposition => :inline
  attribute_accessor :volume_change, :created_by
end
