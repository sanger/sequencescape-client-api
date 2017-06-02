module Sequencescape::Api::Resource::Json
  def self.included(base)
    base.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def self.extended(base)
      base.delegate :json_root, :to => 'self.class'
    end

    def json_root
      self.name.demodulize.underscore
    end
  end

  class CoercionHandler
    include Sequencescape::Api::BasicErrorHandling

    def initialize(api, owner)
      @api, @owner = api, owner
    end

    attr_reader :api

    def new(*args, &block)
      # TODO: Consider updating
      @owner.__send__(:new, *args, &block)
    end
    private :new

    private :api, :new

    def success(json)
      new(api, json, true)
    end
  end

  # Coerces the current object instance to another class.
  def coerce_to(klazz)
    api.read_uuid(self.uuid, CoercionHandler.new(api, klazz))
  end

  def as_json(options = nil)
    options = { :action => :create, :root => true }.merge(options || {})
    send(:"as_json_for_#{options[:action]}", options)
  end

  # Returns the appropriate JSON for when we are creating a resource.  If the resource already exists
  # then we assume that we aren't actually being created, but are being used in the creation of another
  # resource, and send our UUID.  If we are not persisted then all of our attributes need to be sent,
  # regardless of whether we are involved in the creation of ourselves or another resource.
  def as_json_for_create(options)
    persisted? ? uuid : as_json_for_update(options)
  end
  private :as_json_for_create

  # Returns the appropriate JSON for when we are updating a resource.
  def as_json_for_update(options)
    if must_output_full_json?(options)
      json = { }
      json['uuid'] = uuid if options[:uuid] and uuid.present?

      json.merge!(attributes_for_json(options))
      json.merge!(associations_for_json(options.merge(:root => false)))

      return json unless options[:root]
      { json_root => json }
    elsif options[:root]
      # We are the root element so we must output something!
      { json_root => { } }
    else
      # We are not a root element, we haven't been changed, so we might as well not exist!
      nil
    end
  end
  private :as_json_for_update

  def unwrapped_json(json)
    json[(json.keys - [ 'uuids_to_ids' ]).first]
  end
  private :unwrapped_json

  def changed?
    super or associations.values.any?(&:changed?)
  end

  def attributes_for_json(options)
    attributes_to_send_to_server(options).tap do |changed_attributes|
      [ 'created_at', 'updated_at' ].map(&changed_attributes.method(:delete))
    end
  end
  private :attributes_for_json

  def attributes_to_send_to_server(options)
    return attributes if options[:force] or (options[:action] == :create)
    Hash[changes.keys.map { |k| [ k.to_s, send(k) ] }]
  end
  private :attributes_to_send_to_server

  def associations_for_json(options)
    Hash[
      associations.select do |k,v|
        must_output_full_json?(options, v)
      end.map do |k,v|
        [ k.to_s, v.as_json(options) ]
      end
    ]
  end
  private :associations_for_json

  def must_output_full_json?(options, target = self)
    options[:force] or (options[:action] == :create) or target.changed?
  end
  private :must_output_full_json?
end
