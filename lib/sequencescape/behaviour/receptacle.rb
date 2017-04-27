require 'sequencescape/tag'
require 'sequencescape/bait_library'

module Sequencescape::Behaviour
  module Receptacle
    class Aliquot < Sequencescape::Api::Resource
      belongs_to :sample, :disposition => :inline
      composed_of :tag
      composed_of :bait_library

      attribute_accessor :suboptimal
    end

    def self.included(base)
      base.class_eval do
        has_many :aliquots, :disposition => :inline, :class_name => 'Behaviours::Receptacle::Aliquot'
      end
    end
  end
end
