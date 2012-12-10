require 'sequencescape-api/resource'

class Sequencescape::StateChange < ::Sequencescape::Api::Resource
  belongs_to :user
  belongs_to :target, :class_name => 'Asset'
  attribute_accessor :contents          # Array of "contents" to fail, deciphered by the target, can be nil
  attribute_accessor :target_state
  attribute_accessor :previous_state
  attribute_accessor :reason
end

module Lims::Api
  class StateChange
    def initialize(api)
      @api = api
    end 

    def order_uuid
      Settings.temp["Order uuid"]
    end

    def s2_event(status)
      case status
      when "started" then :start
      when "passed" then :complete
      when "failed" then :fail
      when "cancelled" then :cancel
      end
    end

    def create!(attributes = {})
      plate = @api.plate.find(attributes[:target])
      item_role = plate.plate_purpose.uuid

      if item_role.nil?
        tube = @api.tube.find(attributes[:target])
        item_role = tube.purpose.uuid
      end
      @api.update_order.create!(
        :order_uuid => order_uuid,
        :items => {item_role => {
          :event => s2_event(attributes[:target_state]), 
          :uuid => attributes[:target]}}
      )
    end
  end
end
