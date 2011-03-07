require 'active_support'
require 'active_support/basic_object'

require 'sequencescape-api/finder_methods'
require 'sequencescape-api/actions'

require 'ostruct'

# Any interaction with the API isn't done directly through a model but through an instance of this
# class, that proxies the model and ensures that it uses the correct instance of Sequencescape::Api.
class Sequencescape::Api::ResourceModelProxy
  self.instance_methods.each { |m| undef_method(m) unless m.to_s =~ /^(__.+__|respond_to\?|object_id)$/ }

  include ::Sequencescape::Api::FinderMethods
  extend ::Sequencescape::Api::Actions

  def initialize(api, model, actions)
    @api, @model, @actions = api, model, OpenStruct.new(actions)
  end

  attr_reader :api, :actions, :model
  private :api, :actions, :model

  has_create_action

  def respond_to_missing?(name, include_private = false)
    model.respond_to?(name, include_private)
  end

  def method_missing(name, *args, &block)
    args.unshift(api) unless [ :nil? ].include?(name.to_sym)
    model.send(name, *args, &block)
  end
  protected :method_missing

  # Here are some methods that need to be delegated directly.
  delegate :ai, :to => :model
end
