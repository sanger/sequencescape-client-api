module Sequencescape
  class Api
    Error = Class.new(StandardError)

    module GeneralError
      def initialize(json)
        super(json['general'])
      end
    end

    %i[UnauthenticatedError ResourceNotFound].each do |name|
      const_set(name, Class.new(Error) { |c| c.send(:include, GeneralError) })
    end

    class ResourceInvalid < Error
      def initialize(resource)
        super('Resource is reported as invalid by the server')
        @resource = resource
      end

      attr_reader :resource
    end

    module BasicErrorHandling
      def unauthenticated(json)
        raise Sequencescape::Api::UnauthenticatedError, json
      end

      def missing(json)
        raise Sequencescape::Api::ResourceNotFound, json
      end

      def redirection(_json)
        yield(self)
      end
    end
  end
end
