require 'sequencescape-api/associations'
require 'sequencescape-api/composition'
require 'sequencescape-api/actions'

class Sequencescape::Api::JsonError < Sequencescape::Api::Error
  def initialize(path, object)
    super("Cannot find the JSON attributes for #{path.inspect} in #{object.inspect}")
  end
end

class Sequencescape::Api::Resource
  require 'sequencescape-api/resource/instance_methods'
  require 'sequencescape-api/resource/class_methods'
  require 'sequencescape-api/resource/callbacks'
  require 'sequencescape-api/resource/error_handling'
  require 'sequencescape-api/resource/active_model'

  extend ClassMethods
  include InstanceMethods
  include ErrorHandling
  include ActiveModel
  extend Callbacks
  extend Sequencescape::Api::Associations
  extend Sequencescape::Api::Composition
  extend Sequencescape::Api::Actions
end
