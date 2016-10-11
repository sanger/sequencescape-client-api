require 'sequencescape-api/resource'

class Sequencescape::Comment < ::Sequencescape::Api::Resource

  attribute_accessor :description, :title

end
