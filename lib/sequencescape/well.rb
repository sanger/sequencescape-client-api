require 'sequencescape-api/resource'
require 'sequencescape/receptacle'

class Sequencescape::Well < ::Sequencescape::Api::Resource
  include Sequencescape::Receptacle

  belongs_to :plate

  attribute_accessor :location
end
