require 'sequencescape-api/resource'

class Sequencescape::Pipeline < ::Sequencescape::Api::Resource
  has_many :requests, :class_name => 'Sequencescape::Request'
  has_many :batches,  :class_name => 'Sequencescape::Batch' do
    has_create_action
  end
end
