require 'sequencescape/asset'
require 'sequencescape/behaviour/receptacle'

class Sequencescape::Well < ::Sequencescape::Asset
  include Sequencescape::Behaviour::Receptacle

  belongs_to :plate

  attribute_accessor :location, :state
end
