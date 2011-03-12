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
end
