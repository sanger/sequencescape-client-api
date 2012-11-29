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

      def order_uuid(plate_uuid)
        #create_search = @api.create_search.create!(
        #  :model => "order",
        #  :description => "search order from parent plate uuid",
        #  :criteria => {:item => {:uuid => plate_uuid}})

        Settings.temp["Order uuid"]
      end

      def create!(attributes = {})
        response = @api.plate.create!({:number_of_rows => 8, :number_of_columns => 12}.merge(attributes))

        uuid = response.child.uuid
        order = @api.update_order.create!(
          :order_uuid => order_uuid(attributes[:parent]), 
          :items => {uuid => {:uuid => uuid}}
        )

        response
      end
    end
  end
end
