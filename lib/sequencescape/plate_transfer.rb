require 'sequencescape-api/resource'

class Sequencescape::PlateTransfer < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :source, :class_name => 'Asset', :disposition => :inline
  belongs_to :destination, :class_name => 'Asset', :disposition => :inline
  attribute_reader :transfers
  attribute_accessor :targets
end

module Lims
  module Api
    class PlateTransfer
      def initialize(api)
        @api = api
      end

      def create!(attributes = {})
        debugger
        @api.actions.plate_transfer.create!({}.merge(attributes))
      end
      
    end
  end
end
