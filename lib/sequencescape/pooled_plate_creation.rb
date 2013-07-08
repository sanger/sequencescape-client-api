require 'sequencescape-api/resource'

class Sequencescape::PooledPlateCreation < ::Sequencescape::Api::Resource
  belongs_to :user
  has_many   :parents, :class_name => 'Plate', :disposition => :inline
  belongs_to :child_purpose, :class_name => 'PlatePurpose'
  belongs_to :child, :class_name => 'Plate'
end
