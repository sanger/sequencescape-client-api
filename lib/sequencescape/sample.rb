require 'sequencescape-api/resource'

class Sequencescape::Sample < ::Sequencescape::Api::Resource
  has_many :sample_tubes

  attribute_accessor :name
  attribute_accessor :control, :sanger_id
  attribute_accessor :organism, :cohort
  attribute_accessor :country_of_origin, :geographical_region, :ethnicity
  attribute_accessor :mother, :father, :replicate
  attribute_accessor :volume, :supplier_plate_id, :gc_content, :gender, :dna_source
  attribute_accessor :public_name, :common_name, :strain_att, :taxon_id, :reference_genome
  attribute_accessor :ebi_accession_number
  attribute_accessor :description, :sra_hold
end
