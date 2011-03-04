require 'sequencescape-api/resource'

class Sequencescape::Search < ::Sequencescape::Api::Resource
  class BaseHandler
    include Sequencescape::Api::BasicErrorHandling

    def success(attributes)
      raise Sequencescape::Api::Error, 'A success response from a search is unexpected'
    end
  end

  # The response from the server contains the JSON for the resource found.  Using this we can
  # handle the redirection by using the appropriate model based on the root element of the JSON.
  # We don't even need to follow the redirect!
  class SingleResultHandler < BaseHandler
    def initialize(api)
      @api = api
    end

    def redirection(json, &block)
      json.delete('uuids_to_ids')
      Sequencescape::Api::FinderMethods::FindByUuidHandler.new(@api.send(json.keys.first)).success(json)
    end
  end

  # The response from the server contains the JSON for each of the resources found.  We simply
  # need to be able to create the resources from each of these.
  class MultipleResultHandler
    def initialize(model)
      @model = model
    end

    def redirection(json, &block)
      json['searches'].map(&method(:new))
    end

    def new(json)
      @model.new(json, false)
    end
    private :new
  end

  def self.search_action(name)
    line = __LINE__ + 1
    class_eval(%Q{
      def #{name}(criteria)
        api.create(actions.#{name}, { 'search' => criteria }, SingleResultHandler.new(api))
      end
    }, __FILE__, line)
  end

  search_action(:first)
  search_action(:last)

  # When performing a search for all records we need to provide the model (as in 'api.plate') 
  # that we expect to be returned.  So there is a limitation at the moment that the results can
  # only belong to the same model hierarchy.
  def all(model, criteria)
    api.create(actions.all, { 'search' => criteria }, MultipleResultHandler.new(model))
  end
end
