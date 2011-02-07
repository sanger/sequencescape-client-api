require 'sequencescape-api/core_ext'
require 'sequencescape-api/resource_model_proxy'
require 'sequencescape-api/connection_factory'
require 'sequencescape-api/capabilities'

require 'active_support'
require 'active_support/core_ext/class/inheritable_attributes'

class Sequencescape::Api
  extend Sequencescape::Api::ConnectionFactory::Helpers

  def initialize(options = {})
    @model_namespace = options.delete(:namespace) || Sequencescape
    @connection = self.class.connection_factory.create(options).tap do |connection|
      connection.root(&method(:initialize_root))
    end
  end

  attr_reader :capabilities
  delegate :read, :create, :update, :to => :@connection

  def read_uuid(uuid, &block)
    read(@connection.url_for_uuid(uuid), &block)
  end

  def respond_to?(name, include_private = false)
    super || @models.keys.include?(name.to_s)
  end

  def method_missing(name, *args, &block)
    return super unless @models.keys.include?(name.to_s)
    ResourceModelProxy.new(self, model(name), @models[name.to_s])
  end
  protected :method_missing

  def model_name(name)
    model(name).name
  end

  def model(name)
    @model_namespace.const_get(name.to_s.classify)
  rescue NameError => missing_constant_in_user_specified_namespace_fallback
    ::Sequencescape.const_get(name.to_s.classify)
  end
  private :model

  def initialize_root(json)
    @capabilities = Sequencescape::Api.const_get("Version#{json.delete('version') || 1}").new
    @models       = Hash[json.map { |k,v| [ k.to_s.singularize, v['actions'] ] }]
  end
  private :initialize_root

  def inspect
    "#<Sequencescape::Api @connection=#{@connection.inspect}>"
  end
end
