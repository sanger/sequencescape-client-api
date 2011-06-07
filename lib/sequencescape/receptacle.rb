require 'sequencescape/tag'

module Sequencescape::Receptacle
  class Aliquot < Sequencescape::Api::Resource
    belongs_to :sample, :disposition => :inline
    composed_of :tag
  end

  def self.included(base)
    base.class_eval do
      has_many :aliquots, :disposition => :inline, :class_name => 'Receptacle::Aliquot'
    end
  end
end
