module Sequencescape::Api::Resource::InstanceMethods
  def self.included(base) # rubocop:todo Metrics/MethodLength
    base.class_eval do
      attr_reader :api, :actions, :uuid
      private :api, :actions
      alias_method(:model, :class)
      alias_method(:id, :uuid)

      delegate :hash, to: :uuid
      delegate :read_timeout, to: :api

      attribute_accessor :created_at, :updated_at, conversion: :to_time

      private

      def attributes
        @_attributes_
      end
    end
  end

  def eql?(object_or_proxy)
    return false unless object_or_proxy.respond_to?(:uuid)

    uuid.eql?(object_or_proxy.uuid)
  end

  def initialize(api, _json = nil, _wrapped = false)
    @api = api
    @_attributes_ = {}
  end
end
