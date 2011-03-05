require 'active_model/conversion'
require 'active_model/dirty'

# Code that is required to support the ActiveModel basic interface.
module Sequencescape::Api::Resource::ActiveModel
  def self.included(base)
    base.class_eval do
      include ::ActiveModel::Conversion
      include ::ActiveModel::Dirty
    end
  end

  def persisted?
    not self.uuid.nil?
  end
end
