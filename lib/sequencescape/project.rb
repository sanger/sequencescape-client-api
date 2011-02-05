require 'sequencescape-api/resource'

class Sequencescape::Project < ::Sequencescape::Api::Resource
  has_many :submissions, :class_name => 'Sequencescape::Submission'
end
