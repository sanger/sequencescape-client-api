require 'sequencescape-api/resource'

class Sequencescape::BarcodePrinter < Sequencescape::Api::Resource
  attribute_reader :name, :active, :print_service

  attribute_group :service do
    attribute_reader :url
  end

  attribute_group :type do
    attribute_reader :name, :layout
  end
end
