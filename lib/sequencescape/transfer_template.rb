require 'sequencescape-api/resource'

class Sequencescape::TransferTemplate < ::Sequencescape::Api::Resource
  attribute_reader :name
  attribute_reader :transfers

  has_create_action :resource => 'transfer'
  has_create_action :preview!, :action => :preview, :resource => 'transfer'
end

module Lims::Api
  class TransferTemplate
    def initialize(api)
      @api = api
      init_transfer_map
    end

    def init_transfer_map
      @transfer_map = {}
    end

    def stamp_transfer
      %w(A B C D E F G H).each do |letter|
        (1..12).to_a.each do |num|
          key = "#{letter}#{num}"
          @transfer_map[key] = key
        end
      end
    end

    def pool_transfer
      order_uuid = Settings.temp["Order uuid"]
      order = @api.order.find(order_uuid)
      order.parameters["sequencing_pool"].each do |well|
        @transfer_map[well] = "A1"
      end

      # Update order with the state
      @api.update_order.create!(
        :order_uuid => order_uuid,
        :state => {"sequencing_pool" => "A1"}
      )
    end

    def find(uuid)
      case uuid
      when "transfer_templates_1_12" then stamp_transfer
      when "pool_transfer" then pool_transfer
      end
      self
    end

    def preview!(attributes)
      #source, destination = @api.plate.find(attributes[:source]), @api.plate.find(attributes[:destination])
      OpenStruct.new(:transfers => @transfer_map)
    end

    def create!(attributes)
      #TODO ke4 remove the '_uuid endings'
      @api.plate_transfer.create!({
        :source_uuid => attributes[:source],
        :target_uuid => attributes[:destination],
        :transfer_map => @transfer_map
      })
    end
  end
end
