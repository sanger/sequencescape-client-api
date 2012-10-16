require 'sequencescape-api/finder_methods'
require 'sequencescape-api/associations/base'
require 'sequencescape-api/actions'

module Sequencescape::Api::Associations::HasMany
  require 'sequencescape-api/associations/has_many/json'
  require 'sequencescape-api/associations/has_many/validation'
  require 'sequencescape-api/associations/has_many/shared_inline'

  class AssociationProxy < ::Sequencescape::Api::Associations::Base
    include ::Sequencescape::Api::FinderMethods
    include ::Sequencescape::Api::FinderMethods::Caching
    extend  ::Sequencescape::Api::Actions
    include ::Sequencescape::Api::Associations::HasMany::Json
    include ::Sequencescape::Api::Associations::HasMany::Validation
    include Enumerable

    def size
      return @attributes['size'] if api.capabilities.size_in_pages?
      all.size
    end

    def empty?
      return @attributes['size'].zero? if api.capabilities.size_in_pages?
      all.empty?
    end
  end

  class ReceptacleInlineAssociationProxy
    include Enumerable
    include ::Sequencescape::Api::FinderMethods::Delegation
    include ::Sequencescape::Api::Associations::Base::InstanceMethods
    include ::Sequencescape::Api::Associations::HasMany::Json
    include ::Sequencescape::Api::Associations::HasMany::Validation
    include ::Sequencescape::Api::Associations::HasMany::SharedInline

    def initialize(owner, json = nil)
      super
      @objects =
        case
          when @attributes.is_a?(Hash) then @attributes.map { |location, json| new({'location' => location, 'aliquots' => json }) }
        else raise StandardError, "Cannot handle has_many JSON: #{json.inspect}"
        end
    end

  end

  class InlineAssociationProxy 
    include Enumerable
    include ::Sequencescape::Api::FinderMethods::Delegation
    include ::Sequencescape::Api::Associations::Base::InstanceMethods
    include ::Sequencescape::Api::Associations::HasMany::Json
    include ::Sequencescape::Api::Associations::HasMany::Validation
    include ::Sequencescape::Api::Associations::HasMany::SharedInline

    def initialize(owner, json = nil)
      super
      @objects =
        case
        when @attributes.is_a?(Array) then @attributes.map(&method(:new))
        when @attributes.is_a?(Hash)  then @attributes.map { |uuid, json| new(json.merge('uuid' => uuid)) }
        else raise StandardError, "Cannot handle has_many JSON: #{json.inspect}"
        end
    end

    def update_objects_from_json(json)
      all.each do |object|
        object.send(:update_from_json, json[object.uuid]) if json.key?(object.uuid)
      end
    end
    private :update_objects_from_json

    def find(uuid)
      @objects.detect { |o| o.uuid == uuid }
    end

  end

  def has_many(association, options = {}, &block)
    association = association.to_sym

    proxy = Class.new(
      case options[:disposition].try(:to_sym)
      when :inline then InlineAssociationProxy
      when :receptacle_inline then ReceptacleInlineAssociationProxy
      else AssociationProxy
      end
    )
    proxy.association = association
    proxy.options     = options
    proxy.instance_eval(&block) if block_given?

    association_methods(association, :has_many, proxy)
  end
end
