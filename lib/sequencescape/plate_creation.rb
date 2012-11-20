require 'sequencescape-api/resource'

class Sequencescape::PlateCreation < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :parent, :class_name => 'Plate'
  belongs_to :child_purpose, :class_name => 'PlatePurpose'
  belongs_to :child, :class_name => 'Plate'
end

module Lims
  module Api
    class PlateCreation
      def initialize(api)
        @api = api
      end

      def create!(attributes = {})
        @api.plate.create!({:number_of_rows => 8, :number_of_columns => 12}.merge(attributes))
      end
    end
  end
end
