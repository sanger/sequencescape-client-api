require 'sequencescape-api/resource'

class Sequencescape::PlatePurpose < ::Sequencescape::Api::Resource
  has_many :plates do
    has_create_action
  end
end
