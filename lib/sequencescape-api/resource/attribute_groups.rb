require 'active_model/dirty'

module Sequencescape::Api::Resource::Groups
  module InstanceMethods
    def attribute_groups
      @attribute_groups ||= {}
    end

    def attribute_group_json(options)
      attribute_groups.each_with_object({}) do |(k,v), agj|
        agj[k.to_s] = v.send(:as_json_for_update, options) if v.changed?
      end
    end
    private :attribute_group_json

    def changed?
      super or attribute_groups.values.any?(&:changed?)
    end

    def clear_changed_attributes
      super
      attribute_groups.values.map(&:clear_changed_attributes)
    end

    def eager_loaded_attribute?(name)
      super or attribute_groups.key?(name.to_sym)
    end
  end

  module Json
    def as_json_for_update(options)
      super.tap do |json|
        begin
          if options[:root]
            json.fetch(json_root).merge!(attribute_group_json(options))
          else
            json.merge!(attribute_group_json(options))
          end
        rescue KeyError => e
          # If we get a key error, append the json to out exception to assist diagnosing issues
          e.message << " in #{json.to_json}"
          raise e
        end
      end
    end
    private :as_json_for_update
  end

  def self.extended(base)
    base.class_eval do
      include InstanceMethods
    end
  end

  def attribute_group(name, &block)
    proxy_class = Class.new(Proxy)
    proxy_class.instance_eval(&block)
    define_method(name)       {              attribute_groups[name.to_sym] ||= proxy_class.new(self) }
    define_method("#{name}=") { |attributes| attribute_groups[name.to_sym]   = proxy_class.new(self, attributes) }
  end
end

class Sequencescape::Api::Resource::Groups::Proxy
  module InstanceMethods
    def self.included(base)
      base.class_eval do
        attr_reader :attributes
        private :attributes
      end
    end

    def initialize(owner, attributes = {})
      @owner, @attributes = owner, {}
      attributes.each { |k,v| send(:"#{k}=", v) if respond_to?(:"#{k}=", :include_private_methods) }
    end

    def as_json_for_update(options)
      attribute_group_json(options).tap do |agj|
        changes.each { |k, (_, v)| agj[k.to_s] = v }
      end
    end
    private :as_json_for_update

    def clear_changed_attributes
      changed_attributes.clear
    end
    private :clear_changed_attributes
  end

  include InstanceMethods
  include ::ActiveModel::Dirty
  extend Sequencescape::Api::Resource::Attributes
  extend Sequencescape::Api::Resource::Groups
end
