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
        associations[#{association.inspect}] = #{proxy_class_name}.new(self, json)
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
  end
end

require 'sequencescape-api/associations/has_many'
require 'sequencescape-api/associations/belongs_to'
