require 'sequencescape-api/associations'
require 'sequencescape-api/actions'

class Sequencescape::Api::JsonError
  def initialize(path)
    super("Cannot find the JSON attributes for #{path.inspect}")
  end
end

class Sequencescape::Api::Resource
  require 'sequencescape-api/resource/instance_methods'
  require 'sequencescape-api/resource/class_methods'

  extend ClassMethods
  include InstanceMethods
  extend Sequencescape::Api::Associations
  extend Sequencescape::Api::Actions
end
