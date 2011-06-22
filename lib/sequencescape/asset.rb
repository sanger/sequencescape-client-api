require 'sequencescape-api/resource'

class Sequencescape::Asset < ::Sequencescape::Api::Resource
  attribute_accessor :name
  attribute_accessor :qc_state

  # TODO: This is a hack for the warehouse that should be removed!  The type is always known by the application
  # that is using an asset (actually it comes from request JSON) so it's pointless this being here!
  attribute_accessor :type
end
