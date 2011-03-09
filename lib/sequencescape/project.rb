require 'sequencescape-api/resource'

class Sequencescape::Project < ::Sequencescape::Api::Resource
  has_many :submissions

  attr_accessor :name
  attr_accessor :approved, :state
  attr_accessor :project_manager, :cost_code, :funding_comments, :external_funding_source, :budget_division, :budget_cost_centre, :funding_model
  attr_accessor :collaborators
  attr_accessor :roles
end
