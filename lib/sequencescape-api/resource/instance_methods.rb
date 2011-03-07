module Sequencescape::Api::Resource::InstanceMethods
  def self.included(base)
    base.class_eval do
      attr_reader :api, :actions, :attributes, :uuid
      private :api, :actions, :attributes
      alias_method(:model, :class)
      alias_method(:id, :uuid)

      delegate :hash, :to => :uuid

      attribute_accessor :created_at, :updated_at, :conversion => :to_time
    end
  end

  def eql?(object_or_proxy)
    return false unless object_or_proxy.respond_to?(:uuid)
    self.uuid.eql?(object_or_proxy.uuid)
  end

  def initialize(api, json = nil, wrapped = false)
    super
    @api, @attributes = api, {}
  end

  def respond_to?(name, include_private = false)
    super || attributes.key?(name.to_s)
  end

  def method_missing(name, *args, &block)
    (args.empty? and attributes.key?(name.to_s)) ? attributes[name.to_s] : super
  end
  protected :method_missing
end
