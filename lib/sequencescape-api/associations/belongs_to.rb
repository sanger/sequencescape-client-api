require 'sequencescape-api/associations/base'
require 'sequencescape-api/error_handling'

module Sequencescape::Api::Associations::BelongsTo
  module CommonBehaviour
    def self.included(base)
      base.class_eval do
        include Sequencescape::Api::ErrorHandling
      end
    end

    def initialize(*args, &block)
      super
      @object = new(@attributes, false)
    end

    def update_from_json(json)
      @object.send(:update_from_json, json, false)
    end
    private :update_from_json

    def respond_to?(name, include_private = false)
      # One of our methods, or an eager loaded attribute, or the object needs to be loaded & checked
      super or is_handled_by_object_instance?(name) or object.respond_to?(name, include_private)
    end

    def method_missing(name, *args, &block)
      target = is_handled_by_object_instance?(name) ? @object : object
      target.send(name, *args, &block)
    end
    protected :method_missing

    def is_handled_by_object_instance?(name)
      return false if @object.nil?

      # TODO: I really hate special cases!
      case
      when name.to_sym == :uuid                  then true
      when @object.eager_loaded_attribute?(name) then true
      when @object.is_association?(name)         then true
      else false
      end
    end
    private :is_handled_by_object_instance?

    class LoadHandler
      include Sequencescape::Api::BasicErrorHandling

      def initialize(owner)
        @owner = owner
      end

      delegate :loaded, :to => :@owner
      private :loaded

      def new(*args, &block)
        # TODO: Consider updating
        @owner.__send__(:new, *args, &block)
      end
      private :new

      def success(json)
        new(json, true).tap { loaded = true }
      end
    end

    def object
      @object ||= api.read(actions.read, LoadHandler.new(self))
      @object
    end
    private :object

    def as_json(options = nil)
      @object.as_json({ :root => false, :uuid => false }.reverse_merge(options || {}))
    end
  end

  class InlineAssociationProxy < Sequencescape::Api::Associations::Base
    include Sequencescape::Api::Associations::BelongsTo::CommonBehaviour
  end

  class AssociationProxy < Sequencescape::Api::Associations::Base
    include Sequencescape::Api::Associations::BelongsTo::CommonBehaviour

    self.default_attributes_if_missing = {}

    def initialize(*args, &block)
      super
      @loaded = false
    end

    attr_writer :loaded
    private :loaded=

    def object
      @object = nil unless @loaded
      super
    end
    private :object

    def uuid_only?
      @object.__send__(:uuid_only?)
    end

    delegate :hash, to: :uuid

    def eql?(other)
      uuid == other.uuid
    end
  end

  def belongs_to(association, options = {}, &block)
    association = association.to_sym

    proxy = Class.new(
      case options[:disposition].try(:to_sym)
      when :inline then InlineAssociationProxy
      else AssociationProxy
      end
    )
    proxy.association = association
    proxy.options     = options
    proxy.instance_eval(&block) if block_given?

    association_methods(association, :belongs_to, proxy)
  end
end
