require 'sequencescape-api/resource'

class Sequencescape::PlateConversion < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :target, :class_name => 'Plate'
  belongs_to :parent, :class_name => 'Plate'
  belongs_to :purpose, :class_name => 'PlatePurpose'
end
