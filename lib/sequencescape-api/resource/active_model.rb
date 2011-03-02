require 'active_model/conversion'

# Code that is required to support the ActiveModel basic interface.
module Sequencescape::Api::Resource::ActiveModel
  def self.included(base)
    base.class_eval do
      include ::ActiveModel::Conversion

      alias_method :id, :uuid
    end
  end

  def persisted?
    not self.uuid.nil?
  end
end
