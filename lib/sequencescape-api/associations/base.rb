require 'ostruct'

class Sequencescape::Api::Associations::Base
  require 'sequencescape-api/associations/base/instance_methods'

  include InstanceMethods

  def initialize(owner, json = nil)
    super
    @actions = OpenStruct.new(@_attributes_.delete('actions'))
  end

  attr_reader :actions
  private :actions
end
