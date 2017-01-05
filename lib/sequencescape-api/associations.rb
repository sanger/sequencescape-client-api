require 'active_model/errors'

module Sequencescape::Api::Associations
  def self.extended(base)
    base.class_eval do
      include InstanceMethods
      extend HasMany
      extend BelongsTo
    end
  end

  def association_methods(association, type, proxy)
    proxy_class_name = [ association, type, 'proxy'].join('_').classify
    const_set(proxy_class_name.to_sym, proxy)

    line = __LINE__ + 1
    class_eval(%Q{
      def #{association}(reload = false)
        associations[#{association.inspect}]   = nil if !!reload
        associations[#{association.inspect}] ||= #{proxy_class_name}.new(self)
        associations[#{association.inspect}]
      end

      def #{association}=(json)
        association = associations[#{association.inspect}]
        if association.proxy_present?
          association.send(:update_from_json, json)
        else
          associations[#{association.inspect}] = #{proxy_class_name}.new(self, json)
        end
      end
      private #{association.inspect}=

      def #{association}?
        attributes_for?(#{association.inspect})
      end
    }, __FILE__, line)
  end
  private :association_methods

  module InstanceMethods
    def initialize(*args, &block)
      @associations, @errors = {}, nil
      super
    end

    attr_reader :associations
    private :associations

    def is_association?(name)
      associations.key?(name.to_sym)
    end

    def attributes_for(path, default_value_if_missing = nil)
      attributes_from_path(path, default_value_if_missing) or
        raise Sequencescape::Api::JsonError.new(path.to_s, self)
    end

    def attributes_for?(path)
      !!attributes_from_path(path)
    end

    def attributes_from_path(path, default_value_if_missing = nil)
      path.to_s.split('.').inject(attributes) { |k,v| k.try(:[], v) } || default_value_if_missing
    end
    private :attributes_from_path

    def run_validations!
      our_result, their_result = super, @associations.values.all?(&:run_validations!)
      our_result and their_result
    end

    class CompositeErrors < ::ActiveModel::Errors
      def [](field)
        association, *subfield = field.to_s.split('.')
        errors_from_association = associations[association.to_sym].try(:errors).try(:[], subfield.join('.'))
        errors_from_association.blank? ? super : errors_from_association
      end

      def full_messages
        super.concat(association_errors.map(&:full_messages)).flatten
      end

      def empty?
        super and association_errors.all?(&:empty?)
      end

      def clear
        association_errors.map(&:clear)
        super
      end

      def associations(*args, &block)
        # TODO: Consider updating
        @base.__send__(:associations, *args, &block)
      end
      private :associations

      def association_errors
        associations.values.map(&:errors)
      end
      private :association_errors
    end

    def errors
      @errors ||= CompositeErrors.new(self)
    end
  end
end

require 'sequencescape-api/associations/has_many'
require 'sequencescape-api/associations/belongs_to'
