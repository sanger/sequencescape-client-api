require 'sequencescape-api/finder_methods'
require 'sequencescape-api/associations/base'
require 'sequencescape-api/actions'

module Sequencescape::Api::Associations::HasMany
  require 'sequencescape-api/associations/has_many/json'
  require 'sequencescape-api/associations/has_many/validation'

  class AssociationProxy < ::Sequencescape::Api::Associations::Base
    include ::Sequencescape::Api::FinderMethods
    include ::Sequencescape::Api::FinderMethods::Caching
    extend  ::Sequencescape::Api::Actions
    include ::Sequencescape::Api::Associations::HasMany::Json
    include ::Sequencescape::Api::Associations::HasMany::Validation
    include Enumerable

    def size
      return @_attributes_['size'] if api.capabilities.size_in_pages?

      all.size
    end

    def empty?
      return @_attributes_['size'].zero? if api.capabilities.size_in_pages?

      all.empty?
    end

    def present?
      !empty?
    end

    def initialize(owner, json = nil)
      super
      @cached_all = case json
                    when Array then json.map { |js| new_from(js) }
                    end
    end

    def new_from(json)
      case json
      when String then new(uuid: json) # We've recieved an array of strings, prob. uuids
      when Hash then new(json)
      else json
      end
    end

    def update_from_json(_)
      @cached_all = nil
    end
  end

  class InlineAssociationProxy
    include Enumerable
    include ::Sequencescape::Api::FinderMethods::Delegation
    include ::Sequencescape::Api::Associations::Base::InstanceMethods
    include ::Sequencescape::Api::Associations::HasMany::Json
    include ::Sequencescape::Api::Associations::HasMany::Validation

    def initialize(owner, json = nil)
      super
      @objects =
        case
        when @_attributes_.is_a?(Array) then @_attributes_.map(&method(:new))
        when @_attributes_.is_a?(Hash)  then @_attributes_.map { |uuid, json| new(json.merge('uuid' => uuid)) }
        else raise StandardError, "Cannot handle has_many JSON: #{json.inspect}"
        end
    end

    def update_from_json(json)
      case
      when json.is_a?(Array) then @objects = json.map(&method(:new))
      when json.is_a?(Hash)  then update_objects_from_json(json)
      else raise StandardError, "Cannot handle has_many JSON: #{json.inspect}"
      end
    end
    private :update_from_json

    def update_objects_from_json(json)
      all.each do |object|
        object.send(:update_from_json, json[object.uuid]) if json.key?(object.uuid)
      end
    end
    private :update_objects_from_json

    def find(uuid)
      @objects.detect { |o| o.uuid == uuid }
    end

    def all
      @objects
    end

    def each_page
      yield(@objects)
    end

    def new(json, &block)
      super(json, false, &block)
    end
    private :new

    # We are changed if any of our objects have been changed.
    def changed?
      @objects.any?(&:changed?)
    end
  end

  def has_many(association, options = {}, &block) # rubocop:todo Metrics/MethodLength
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

    association_methods(association, :has_many, proxy)
  end
end
