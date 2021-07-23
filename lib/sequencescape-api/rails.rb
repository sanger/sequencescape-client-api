module Sequencescape::Api::Rails
  # Including this module into your Rails ApplicationController adds a before filter that will
  # provide a Sequencescape::Api instance to use, accessible through `api`.
  module ApplicationController
    def self.included(base) # rubocop:todo Metrics/MethodLength
      base.class_eval do
        attr_reader :api
        private :api

        if respond_to?(:before_action)
          before_action :configure_api
        else
          before_filter :configure_api
        end

        # Order is important here: later ones override earlier.
        rescue_from(::Sequencescape::Api::Error,                with: :sequencescape_api_error_handler)
        rescue_from(::Sequencescape::Api::UnauthenticatedError, with: :sequencescape_api_unauthenticated_handler)
      end
    end

    private

    def api_class
      ::Sequencescape::Api
    end

    def configure_api
      @api = api_class.new(api_connection_options)
    end

    def api_connection_options
      raise Sequencescape::Api::Error, "api_connection_options not implemented for #{self.class}"
    end

    def sequencescape_api_error_handler(exception)
      Rails.logger.error "#{exception}, #{exception.backtrace}"
      raise StandardError, "There is an issue with the API connection to Sequencescape (#{exception.message})"
    end

    def sequencescape_api_unauthenticated_handler(exception)
      Rails.logger.error "#{exception}, #{exception.backtrace}"
      raise StandardError, 'You are not authenticated; please visit the WTSI login page'
    end
  end

  # Including this module into your Rails model indicates that the model is associated with
  # a remote resource.  This then means that your model table needs a string 'uuid' column
  # and that when you perform a save the remote resource will also be saved if it can or
  # needs to be.  The remote resource is exposed through `remote_resource` which you are
  # advised to use `delegate` to hand off to.
  module Resourced
    def self.included(base)
      base.class_eval do
        attr_protected :remote_resource, :uuid
        validates_presence_of :uuid, allow_blank: false
        before_save :save_remote_resource
      end
    end

    def remote_resource=(resource)
      @remote_resource = resource
      self[:uuid] = @remote_resource.uuid
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

      self[:uuid] = @remote_resource
      @remote_resource.save
    end
    private :save_remote_resource
  end
end
