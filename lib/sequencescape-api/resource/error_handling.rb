require 'active_model/naming'
require 'active_model/translation'

# Uh, ok, so why do I have to include these if I'm not going to use them!?!!
require 'active_model/deprecated_error_methods'
require 'active_model/errors'

# Uh, ok, so why do I have to include these when I've kind of said I want everything!?!!
require 'active_model/validator'
require 'active_model/validations'

module Sequencescape::Api::Resource::ErrorHandling
  def self.included(base)
    base.class_eval do
      extend ActiveModel::Translation
      include ActiveModel::Validations
      include ActiveModel::Validations::Callbacks
    end
  end
end
