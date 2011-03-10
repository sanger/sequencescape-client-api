require 'sequencescape-api/resource'

class Sequencescape::SubmissionTemplate < ::Sequencescape::Api::Resource
  has_many :submissions do
    has_create_action
  end

  attribute_accessor :name
end
