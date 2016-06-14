require 'sequencescape-api/resource'

class Sequencescape::LotType < ::Sequencescape::Api::Resource

  module LotCreator
    def create!(attributes=nil)
      attributes ||= {}
      new({}, false).tap do |lot|
        api.create(actions.create, { 'lot' => attributes }, Sequencescape::Api::ModifyingHandler.new(lot))
      end
    end
  end

  has_many :lots do
    # has_create_action
    include Sequencescape::LotType::LotCreator
  end

  attribute_accessor :name, :template_class, :printer_type, :qcable_name
end
