module Sequencescape
  class Api
    class JsonError < Error
      def initialize(path)
        super("The JSON is invalid in #{path.inspect}")
      end
    end
  end
end

require 'sequencescape-api/associations/has_many'
require 'sequencescape-api/associations/belongs_to'

module Sequencescape
  class Api
    module Associations
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
          path.to_s.split('.').inject(attributes) { |k,v| k.try(:[], v) } or
            raise Sequencescape::Api::JsonError, path.to_s
        end

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
  end
end
