class Sequencescape::Api::JsonError < Sequencescape::Api::Error
  def initialize(path)
    super("The JSON is invalid in #{path.inspect}")
  end
end

module Sequencescape::Api::Associations
  def self.extended(base)
    base.class_eval do
      include InstanceMethods
      extend HasMany
      extend BelongsTo
    end
  end

  module InstanceMethods
    def initialize(*args, &block)
      super
      @associations = {}
    end

    attr_reader :associations
    private :associations

    def attributes_for(path)
      attributes_from_path(path) or raise Sequencescape::Api::JsonError, path.to_s
    end

    def attributes_for?(path)
      !!attributes_from_path(path)
    end

    def attributes_from_path(path)
      path.to_s.split('.').inject(attributes) { |k,v| k.try(:[], v) }
    end
    private :attributes_from_path

    def update_attributes!(*args)
      reset_all_associations
      super
    end

    def reset_all_associations
      @associations.clear
    end
    private :reset_all_associations
  end
end

require 'sequencescape-api/associations/has_many'
require 'sequencescape-api/associations/belongs_to'
