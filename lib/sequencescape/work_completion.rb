require 'sequencescape-api/resource'

class Sequencescape::WorkCompletion < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :target, :class_name => 'Asset'

  # This should really be a has_many, but we'll need
  # to get assignment from arrays of strings working first.
  attribute_accessor :submissions
end
