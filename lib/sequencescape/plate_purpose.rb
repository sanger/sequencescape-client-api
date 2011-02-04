require 'sequencescape-api/resource'

module Sequencescape
  class PlatePurpose < ::Sequencescape::Api::Resource
    has_many :plates, :class_name => 'Sequencescape::Plate' do
      has_create_action
    end
  end
end
