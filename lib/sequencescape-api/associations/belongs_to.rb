require 'sequencescape-api/associations/base'

module Sequencescape::Api::Associations::BelongsTo
  class AssociationProxy < Sequencescape::Api::Associations::Base
    write_inheritable_attribute(:default_attributes_if_missing, {})

    def initialize(*args, &block)
      super
      @object, @loaded = new(@attributes, false), false
    end

    def respond_to?(name, include_private = false)
      # One of our methods, or an eager loaded attribute, or the object needs to be loaded & checked
      super or @object.eager_loaded_attribute?(name) or object.respond_to?(name, include_private)
    end

    def method_missing(name, *args, &block)
      target = @object.eager_loaded_attribute?(name) ? @object : object
      target.send(name, *args, &block)
    end
    protected :method_missing

    class LoadHandler
      include Sequencescape::Api::BasicErrorHandling

      def initialize(owner)
        @owner = owner
      end

      delegate :new, :loaded, :to => :@owner
      private :new, :loaded

      def success(json)
        new(json, true).tap { loaded = true }
      end
    end

    attr_writer :loaded
    private :loaded=

    def object
      @object   = nil unless @loaded
      @object ||= api.read(actions.read, LoadHandler.new(self))
      @object
    end
    private :object

    def as_json(options = nil)
      @object.as_json({ :root => false, :uuid => false }.reverse_merge(options || {}))
    end

    delegate :hash, :to => :@object
    def eql?(proxy_or_object)
      proxy_or_object = proxy_or_object.instance_variable_get(:@object) if proxy_or_object.is_a?(self.class)
      @object.eql?(proxy_or_object)
    end
  end

  def belongs_to(association, options = {}, &block)
    association = association.to_sym

    proxy = Class.new(AssociationProxy)
    proxy.association = association
    proxy.options     = options
    proxy.instance_eval(&block) if block_given?

    association_methods(association, :belongs_to, proxy)
  end
end
