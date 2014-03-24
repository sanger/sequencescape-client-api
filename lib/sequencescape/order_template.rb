require 'sequencescape-api/resource'

class Sequencescape::OrderTemplate < ::Sequencescape::Api::Resource

  module OrderCreator
    def create!(attributes=nil)
      attributes ||= {}
      new({}, false).tap do |order|
        api.create(actions.create, { 'order' => attributes }, Sequencescape::Api::ModifyingHandler.new(order))
      end
    end
  end

  has_many :orders do
    include Sequencescape::OrderTemplate::OrderCreator
  end

  attribute_accessor :name
end
