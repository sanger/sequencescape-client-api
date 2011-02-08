require 'sequencescape-api/finder_methods'
require 'sequencescape-api/associations/base'
require 'sequencescape-api/actions'

module Sequencescape::Api::Associations::HasMany
  class AssociationProxy < ::Sequencescape::Api::Associations::Base
    include ::Sequencescape::Api::FinderMethods
    extend  ::Sequencescape::Api::Actions
  end

  class InlineAssociationProxy 
    include Enumerable
    include ::Sequencescape::Api::FinderMethods::Delegation

    def initialize(owner, association, options)
      @owner   = owner
      @model   = (options[:class_name] || api.model_name(association)).constantize
      @objects = @owner.attributes_for(association).map(&method(:new))
    end

    attr_reader :model
    delegate :api, :to => :@owner
    private :api, :model

    def find(uuid)
      @objects.detect { |o| o.uuid == uuid }
    end

    def all
      @objects
    end

    def new(json, &block)
      model.new(api, json, true, &block)
    end
    private :new
  end

  def has_many(association, options = {}, &block)
    association = association.to_sym

    proxy = Class.new(
      case options[:disposition].try(:to_sym)
      when :inline then InlineAssociationProxy
      else AssociationProxy
      end
    )
    proxy.instance_eval(&block) if block_given?

    const_set(:"#{association.to_s.classify}HasManyProxy", proxy)

    line = __LINE__ + 1
    class_eval(%Q{
      def #{association}(reload = false)
        associations[#{association.inspect}]   = nil if reload
        associations[#{association.inspect}] ||= #{association.to_s.classify}HasManyProxy.new(self, #{association.inspect}, #{options.inspect})
        associations[#{association.inspect}]
      end

      def #{association}?
        attributes_for?(#{association.inspect})
      end
    }, __FILE__, line)
  end
end
