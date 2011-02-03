require 'sequencescape-api/resource'

module Sequencescape
  class Request < ::Sequencescape::Api::Resource
    belongs_to :project, :class_name => 'Sequencescape::Project'
    belongs_to :study,   :class_name => 'Sequencescape::Study'
    belongs_to :sample,  :class_name => 'Sequencescape::Sample'

    belongs_to :source_asset, :class_name => 'Sequencescape::Asset'
    belongs_to :target_asset, :class_name => 'Sequencescape::Asset'
  end
end
