
require 'sequencescape-api/resource'

class Sequencescape::QcableCreator < ::Sequencescape::Api::Resource

  belongs_to :user
  belongs_to :lot

  has_many :qcables

  attribute_accessor :count, :barcodes

end
