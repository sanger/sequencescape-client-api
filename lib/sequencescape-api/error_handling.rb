require 'active_model/naming'
require 'active_model/translation'

# Uh, ok, so why do I have to include these if I'm not going to use them!?!!
require 'active_model/errors'

# Uh, ok, so why do I have to include these when I've kind of said I want everything!?!!
require 'active_model/validator'
require 'active_model/validations'
require 'active_model/callbacks'

module Sequencescape::Api::ErrorHandling
  def self.included(base)
    base.class_eval do
      extend ActiveModel::Translation
      include ActiveModel::Validations
      include ActiveModel::Validations::Callbacks
      include TurnOffValidationOfUuidOnlyRecords
    end
  end

  #--
  # A bit of a fiddle this but any records that are UUID only are typically coming from the user
  # having selected a load.  If this has happened then there is no data and so none of the
  # validations should be run.
  #++
  module TurnOffValidationOfUuidOnlyRecords
    def run_validations!
      uuid_only? ? true : super
    end

    def uuid_only=(value)
      @uuid_only = value
    end
    private :uuid_only=

    def uuid_only?
      @uuid_only
    end
    private :uuid_only?
  end
end
