module Sequencescape::Api::Rails
  # Including this module into your Rails ApplicationController adds a before filter that will
  # provide a user (based on the WTSISignOn cookie) specific Sequencescape::Api instance to
  # use, accessible through `api`.
  module ApplicationController
    def self.included(base)
      base.class_eval do
        attr_reader :api
        private :api

        before_filter :configure_api
      end
    end

    def api_class
      ::Sequencescape::Api
    end
    private :api_class

    def configure_api
      @api = api_class.new(:cookie => cookies['WTSISignOn'])
    end
    private :configure_api
  end

  # Including this module into your Rails model indicates that the model is associated with
  # a remote resource.  This then means that your model table needs a string 'uuid' column
  # and that when you perform a save the remote resource will also be saved if it can or
  # needs to be.  The remote resource is exposed through `remote_resource` which you are 
  # advised to use `delegate` to hand off to.
  module Resourced
    def self.included(base)
      base.class_eval do
        validates_presence_of :uuid, :allow_blank => false
        before_save :save_remote_resource
      end
    end

    def uuid
      self[:uuid]
    end
    private :uuid

    def remote_resource
      @remote_resource ||= api.find(uuid)
    end
    private :remote_resource

    def save_remote_resource
      return true if @remote_resource.nil?
      return true unless @remote_resource.can_save?
      @remote_resource.save
    end
    private :save_remote_resource
  end
end
