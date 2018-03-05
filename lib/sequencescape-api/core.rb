require 'sequencescape-api/core_ext'
require 'sequencescape-api/resource_model_proxy'
require 'sequencescape-api/connection_factory'
require 'sequencescape-api/capabilities'

require 'active_support'
require 'active_support/core_ext/class'

class Sequencescape::Api
  extend Sequencescape::Api::ConnectionFactory::Helpers

  def initialize(options = {})
    @models, @model_namespace = {}, options.delete(:namespace) || Sequencescape
    @model_namespace = @model_namespace.constantize if @model_namespace.is_a?(String)
    @connection = self.class.connection_factory.create(options).tap do |connection|
      connection.root(self)
    end
  end

  attr_reader :capabilities
  delegate :read, :create, :create_from_file, :update, :retrieve, :to => :@connection

  def read_uuid(uuid, handler)
    read(@connection.url_for_uuid(uuid), handler)
  end

  def respond_to?(name, include_private = false)
    super || @models.keys.include?(name.to_s)
  end

  def method_missing(name, *args, &block)
    return super unless @models.keys.include?(name.to_s)
    ResourceModelProxy.new(self, model(name), @models[name.to_s])
  end
  protected :method_missing

  def model(name)
    parts = name.to_s.split('::').map(&:classify)
    raise StandardError, "#{name.inspect} is rooted and that is not supported" if parts.first.blank?
    parts.inject(@model_namespace) { |context, part| context.const_get(part) }
  rescue NameError => missing_constant_in_user_specified_namespace_fallback
    raise if @model_namespace == ::Sequencescape
    parts.inject([ ::Sequencescape, @model_namespace ]) do |(source, dest), part|
      const_from_source = source.const_get(part)
      if dest.const_defined?(part)
        [ const_from_source, dest.const_get(part) ]
      else
        [ const_from_source, dest.const_set(part, const_from_source) ]
      end
    end.last
  end

  include BasicErrorHandling

  def success(json)
    @capabilities = Sequencescape::Api.const_get("Version#{json.delete('revision') || 1}").new
    @models       = json.each_with_object({}) { |(k, v), models| models[k.to_s.singularize] = v['actions'] }
  end

  def inspect
    "#<Sequencescape::Api @connection=#{@connection.inspect}>"
  end
end
