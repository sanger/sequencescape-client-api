require 'ostruct'

class Sequencescape::Api::Associations::Base
  def initialize(owner, association, options)
    @owner      = owner
    @attributes = owner.attributes_for(association)
    @actions    = OpenStruct.new(@attributes.delete('actions'))
    @model      = (options[:class_name] || api.model_name(association)).constantize
  end

  attr_reader :actions, :model
  delegate :api, :to => :@owner
  private :api, :actions, :model

  def new(*args, &block)
    model.new(api, *args, &block)
  end
  private :new
end
