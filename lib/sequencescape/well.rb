require 'sequencescape/asset'
require 'sequencescape/behaviour/receptacle'
require 'sequencescape/behaviour/state_driven'

class Sequencescape::Well < ::Sequencescape::Asset
  include Sequencescape::Behaviour::Receptacle
  include Sequencescape::Behaviour::StateDriven

  belongs_to :plate

  attribute_accessor :location, :pool

  def pool_id
    pool['id']
  end
end
