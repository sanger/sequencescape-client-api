require 'sequencescape-api/resource'

class Sequencescape::QcFile < ::Sequencescape::Api::Resource
  belongs_to :asset

  attribute_accessor :filename, :size

  def retrieve
    api.retrieve(actions.read, Sequencescape::Api::ModifyingHandler.new(self), 'sequencescape/qc_file')
  end
end
