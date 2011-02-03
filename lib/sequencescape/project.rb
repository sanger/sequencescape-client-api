require 'sequencescape-api/resource'

module Sequencescape
  class Project < ::Sequencescape::Api::Resource
    has_many :submissions, :class_name => 'Sequencescape::Submission'
  end
end
