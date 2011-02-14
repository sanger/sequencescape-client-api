require 'sequencescape-api/associations'
require 'sequencescape-api/composition'
require 'sequencescape-api/actions'

class Sequencescape::Api::JsonError
  def initialize(path)
    super("Cannot find the JSON attributes for #{path.inspect}")
  end
end

class Sequencescape::Api::Resource
  require 'sequencescape-api/resource/instance_methods'
  require 'sequencescape-api/resource/class_methods'
  require 'sequencescape-api/resource/callbacks'

  extend ClassMethods
  include InstanceMethods
  extend Callbacks
  extend Sequencescape::Api::Associations
  extend Sequencescape::Api::Composition
  extend Sequencescape::Api::Actions
end
