class Sequencescape::Api::ModifyingHandler
  include Sequencescape::Api::BasicErrorHandling

  def initialize(owner)
    @owner = owner
  end

  delegate :update_from_json, :to => :@owner
  private :update_from_json

  def error(field_and_errors_pair)
    field, errors = field_and_errors_pair
    Array(errors).each { |error| @owner.errors.add(field, error) }
  end
  private :error

  def object_error(message)
    @owner.errors.add(:base, message)
  end
  private :object_error

  def success(json)
    update_from_json(json, true)
  end

  def failure(json)
    Array(json.fetch('content', [])).map(&method(:error))
    Array(json.fetch('general', [])).map(&method(:object_error))

    raise Sequencescape::Api::ResourceInvalid, @owner
  end
end

module Sequencescape::Api::Actions
  def has_create_action(name = :create!, options = {})
    action = options[:action] || :create

    line = __LINE__ + 1
    class_eval(%Q{
      def #{name}(attributes = nil)
        attributes ||= {}
        new(attributes, false).tap do |object|
          object.send(:_run_create_callbacks) do
            api.create(
              actions.#{options[:action] || :create},
              { model.json_root => attributes },
              Sequencescape::Api::ModifyingHandler.new(object)
            )
          end
        end
      end
    }, __FILE__, line)
  end

  def has_update_action(name, options = {})
    api_method = options[:verb] == :create ? :create : :update

    line = __LINE__ + 1
    class_eval(%Q{
      def #{name}(body = nil)
        body ||= {}
        api.#{api_method}(
          actions.#{options[:action] || :update},
          { model.json_root => body },
          Sequencescape::Api::ModifyingHandler.new(self)
        )
      end
    }, __FILE__, line)
  end
end
