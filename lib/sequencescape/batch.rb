require 'sequencescape-api/resource'

class Sequencescape::Batch < ::Sequencescape::Api::Resource
  belongs_to  :pipeline
  has_many    :requests, :disposition => :inline
  composed_of :user

  has_update_action :start!,    :action => 'start'
  has_update_action :complete!, :action => 'complete'
  has_update_action :release!,  :action => 'release'

  attribute_accessor :state, :production_state, :qc_state, :barcode

  def self.state_method(name)
    class_eval("def #{name}? ; state == #{name.to_s.inspect} ; end")
  end

  state_method(:pending)
  state_method(:started)
  state_method(:completed)
  state_method(:released)

  validates_presence_of :requests, :allow_blank => false
end
