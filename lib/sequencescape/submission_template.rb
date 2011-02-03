require 'sequencescape-api/resource'

module Sequencescape
  class SubmissionTemplate < ::Sequencescape::Api::Resource
    has_many :submissions, :class_name => 'Sequencescape::Submission' do
      has_create_action
    end
  end
end
