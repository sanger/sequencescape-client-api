module Sequencescape
  class Api
    module Rails
      module ApplicationController
        def self.included(base)
          base.class_eval do
            attr_reader :api
            before_filter :configure_api
          end
        end

        def configure_api
          @api = ::Sequencescape::Api.new(:cookie => self.cookies['WTSISignOn'])
        end
        private :configure_api
      end
    end
  end
end
