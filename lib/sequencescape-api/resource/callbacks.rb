require 'active_model/callbacks'

module Sequencescape::Api::Resource::Callbacks
  def self.extended(base)
    base.class_eval do
      base.extend ActiveModel::Callbacks
      define_model_callbacks :create
    end
  end
end
