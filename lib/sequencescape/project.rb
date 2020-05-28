require 'sequencescape-api/resource'

class Sequencescape::Project < ::Sequencescape::Api::Resource
  has_many :submissions

  attribute_accessor :name
  attribute_accessor :approved, :state
  attribute_accessor :project_manager, :cost_code, :funding_comments, :external_funding_source, :budget_division
  attribute_accessor :budget_cost_centre, :funding_model
  attribute_accessor :collaborators
  attribute_accessor :roles
end
