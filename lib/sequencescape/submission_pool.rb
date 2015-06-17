require 'sequencescape-api/resource'

class Sequencescape::SubmissionPool < ::Sequencescape::Api::Resource

  attribute_reader :plates_in_submission
  attribute_reader :used_tag2_layout_templates


end
