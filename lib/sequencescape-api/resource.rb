require 'sequencescape-api/associations'
require 'sequencescape-api/composition'
require 'sequencescape-api/actions'
require 'sequencescape-api/error_handling'

class Sequencescape::Api::JsonError < Sequencescape::Api::Error
  def initialize(path, object)
    super("Cannot find the JSON attributes for #{path.inspect} in #{object.inspect}")
  end
end

class Sequencescape::Api::Resource
  require 'sequencescape-api/resource/instance_methods'
  require 'sequencescape-api/resource/modifications'
  require 'sequencescape-api/resource/attributes'
  require 'sequencescape-api/resource/active_model'
  require 'sequencescape-api/resource/json'
  require 'sequencescape-api/resource/attribute_groups'

  include ActiveModel
  extend Attributes
  include InstanceMethods
  include Modifications
  include ::Sequencescape::Api::ErrorHandling
  include Json

  extend  Groups
  include Groups::Json

  def initialize(*args, &block)
    super
    after_load
  end

  def after_load
    # Does nothing
  end
  private :after_load

  extend Sequencescape::Api::Associations
  extend Sequencescape::Api::Composition
  extend Sequencescape::Api::Actions

  def self.is_a_proxied_model?
    false
  end
end
