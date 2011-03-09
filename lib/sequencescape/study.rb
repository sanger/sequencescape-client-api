require 'sequencescape-api/resource'

class Sequencescape::Study < ::Sequencescape::Api::Resource
  has_many :projects
  has_many :asset_groups
  has_many :samples

  attribute_accessor :name, :abbreviation, :abstract, :description, :state, :type
  attribute_accessor :sac_sponsor, :accession_number, :reference_genome, :ethically_approved
  attribute_accessor :contaminated_human_dna, :contains_human_dna
  attribute_accessor :data_release_sort_of_study, :data_release_strategy

  validates :name, :presence => true
end
