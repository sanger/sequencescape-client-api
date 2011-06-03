module Unauthorised
  MODELS_THROUGH_API = [ :model_a, :model_b, :model_c ]

  class ModelA < Sequencescape::Api::Resource
    has_many :model_bs

    attribute_accessor :name, :data
  end

  class ModelB < Sequencescape::Api::Resource
    belongs_to :model_a
    belongs_to :model_by_simple_name, :class_name => 'ModelA'
    belongs_to :model_by_full_name, :class_name => 'Nested::Model'
    belongs_to :model_with_early_data, :class_name => 'ModelA'
  end

  class ModelC < Sequencescape::Api::Resource
    has_many :model_bs, :disposition => :inline

    attribute_accessor :attribute_validated_at_client, :attribute_validated_at_server
    validates_each(:attribute_validated_at_client) do |record, attribute, value|
      record.errors.add(attribute, 'cannot be set') unless value.blank?
    end

    attribute_accessor :changes_during_update, :remains_same_during_update

    attribute_reader :read_only
    attribute_writer :write_only
  end

  class Page < Sequencescape::Api::Resource
  end

  module Nested
    class Model < Sequencescape::Api::Resource
      attribute_accessor :name
    end
  end
end

module Authenticated
  MODELS_THROUGH_API = [ :model_c, :model_d ]

  class ModelC < Sequencescape::Api::Resource

  end
  class ModelD < Sequencescape::Api::Resource

  end
end
