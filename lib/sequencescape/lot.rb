require 'sequencescape-api/resource'

class Sequencescape::Lot < ::Sequencescape::Api::Resource

  belongs_to :user
  belongs_to :lot_type
  belongs_to :template

  attribute_accessor :lot_number, :recieved_at, :template_name, :lot_type_name
end
