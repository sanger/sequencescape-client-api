require 'ostruct'

module Sequencescape::Api::Resource::InstanceMethods
  def self.included(base)
    base.class_eval do
      attr_reader :api, :actions, :attributes, :uuid
      private :api, :actions, :attributes
      alias_method(:model, :class)

      delegate :hash, :to => :uuid

      time_attribute :created_at, :updated_at
    end
  end

  def eql?(object_or_proxy)
    return false unless object_or_proxy.respond_to?(:uuid)
    self.uuid.eql?(object_or_proxy.uuid)
  end

  def initialize(api, json = nil, wrapped = false)
    @api = api
  end

  def respond_to?(name, include_private = false)
    super || attributes.key?(name.to_s)
  end

  def method_missing(name, *args, &block)
    return yield if name.to_s =~ /^_run_.+_callbacks$/
    (args.empty? and attributes.key?(name.to_s)) ? attributes[name.to_s] : super
  end
  protected :method_missing

  def as_json(options = nil)
    uuid
  end
  protected :as_json

  def unwrapped_json(json)
    json[(json.keys - [ 'uuids_to_ids' ]).first]
  end
  private :unwrapped_json
end
