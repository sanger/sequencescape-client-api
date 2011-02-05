require 'ostruct'

class Sequencescape::Api::Associations::Base
  def initialize(owner, name, options)
    @owner      = owner
    @attributes = owner.attributes_for(name)
    @actions    = OpenStruct.new(@attributes.delete('actions'))
    @model      = options[:class_name].constantize
  end

  attr_reader :actions, :model
  delegate :api, :to => :@owner
  private :api, :actions, :model

  def new(*args, &block)
    model.new(api, *args, &block)
  end
  private :new
end
