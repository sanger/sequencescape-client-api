module Sequencescape::Api::Resource::InstanceMethods
  def self.included(base)
    base.class_eval do
      attr_reader :api, :actions, :uuid
      private :api, :actions
      alias_method(:model, :class)
      alias_method(:id, :uuid)

      delegate :hash, :to => :uuid
      delegate :read_timeout, :to => :api

      attribute_accessor :created_at, :updated_at, :conversion => :to_time

      private

      def attributes
        @_attributes_
      end
    end
  end

  def eql?(object_or_proxy)
    return false unless object_or_proxy.respond_to?(:uuid)
    self.uuid.eql?(object_or_proxy.uuid)
  end

  def initialize(api, json = nil, wrapped = false)
    @api, @_attributes_ = api, {}
  end
end
