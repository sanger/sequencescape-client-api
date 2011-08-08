require 'sequencescape-api/resource'

class Sequencescape::Sample < ::Sequencescape::Api::Resource
  has_many :sample_tubes

  attribute_group :sanger do
    attribute_accessor :name, :sample_id, :resubmitted, :description
  end
  attribute_group :supplier do
    attribute_accessor :sample_name, :storage_conditions

    attribute_group :collection do
      attribute_accessor :date
    end
    attribute_group :extraction do
      attribute_accessor :date, :method
    end
    attribute_group :purification do
      attribute_accessor :purified, :method
    end
    attribute_group :measurements do
      attribute_accessor :volume, :concentration, :concentration_determined_by
      attribute_accessor :gc_content, :gender
    end
  end
  attribute_group :source do
    attribute_accessor :dna_source, :cohort, :country, :region, :ethnicity, :control
  end
  attribute_group :family do
    attribute_accessor :mother, :father, :replicate, :sibling
  end
  attribute_group :taxonomy do
    attribute_accessor :id, :strain, :common_name, :organism
  end
  attribute_group :reference do
    attribute_accessor :genome
  end
  attribute_group :data_release do
    attribute_accessor :sample_type, :accession_number, :visibility, :public_name, :description

    attribute_group :metagenomics do
      attribute_accessor :genotype, :phenotype
      attribute_accessor :age, :developmental_stage, :cell_type, :disease_state
      attribute_accessor :compound, :dose, :immunoprecipitate, :growth_condition
      attribute_accessor :rnai, :organism_part, :time_point, :treatment, :subject, :disease
    end
    attribute_group :managed do
      attribute_accessor :treatment, :subject, :disease
    end
  end
end
