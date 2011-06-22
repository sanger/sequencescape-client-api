require 'sequencescape/asset'
require 'sequencescape/behaviour/receptacle'

class Sequencescape::Lane < ::Sequencescape::Asset
  include Sequencescape::Behaviour::Receptacle

  attribute_accessor :external_release
end
