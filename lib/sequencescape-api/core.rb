require 'sequencescape-api/core_ext'
require 'sequencescape-api/resource_model_proxy'
require 'sequencescape-api/connection_factory'

require 'active_support'
require 'active_support/core_ext/class/inheritable_attributes'

module Sequencescape
  class Api
    extend Sequencescape::Api::ConnectionFactory::Helpers

    def initialize(options = {})
      @connection = self.class.connection_factory.create(options).tap do |connection|
        connection.root(&method(:initialize_root))
      end
    end

    delegate :read, :create, :update, :to => :@connection

    def read_uuid(uuid, &block)
      read(@connection.url_for_uuid(uuid), &block)
    end

    def respond_to?(name, include_private = false)
      super || @models.keys.include?(name.to_s)
    end

    def method_missing(name, *args, &block)
      return super unless @models.keys.include?(name.to_s)
      ResourceModelProxy.new(self, "Sequencescape::#{name.to_s.classify}".constantize, @models[name.to_s])
    end
    protected :method_missing

    def initialize_root(json)
      @models = Hash[json.map { |k,v| [ k.to_s.singularize, v['actions'] ] }]
    end
    private :initialize_root

    def inspect
      "#<Sequencescape::Api @connection=#{@connection.inspect}>"
    end
  end
end
