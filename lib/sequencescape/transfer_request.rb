require 'sequencescape-api/resource'

class Sequencescape::TransferRequest < ::Sequencescape::Api::Resource

  belongs_to :source_asset, :class_name => 'Asset'
  belongs_to :target_asset, :class_name => 'Asset'
  belongs_to :submission, :class_name => 'Submission'
  belongs_to :outer_request, :class_name => 'Request'

  attribute_accessor :type, :state, :submission_id, :volume
end
