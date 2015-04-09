require 'sequencescape-api/resource'

class Sequencescape::Comment

  include Sequencescape::Api::Composition::Target

  attribute_accessor :description, :title

end
