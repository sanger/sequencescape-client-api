class Sequencescape::Api::ModifyingHandler
  include Sequencescape::Api::BasicErrorHandling

  def initialize(owner)
    @owner = owner
  end

  def update_from_json(*args, &block)
    # TODO: Consider updating
    @owner.__send__(:update_from_json, *args, &block)
  end
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

module Sequencescape::Api::Resource::Modifications
  def initialize(api, json = nil, wrapped = false)
    super
    update_from_json(json, wrapped)
    clear_changes_information
  end

  def update_attributes!(attributes)
    clear_changes_information
    update_from_json(attributes, false)
    modify!(action: :update)
  end
  alias update! update_attributes!

  def save!(options = nil)
    action = persisted? ? :update : :create
    modify!((options || {}).merge({ action: action }))
  end

  # rubocop:todo Metrics/MethodLength
  def modify!(options) # rubocop:todo Metrics/CyclomaticComplexity
    raise Sequencescape::Api::Error, 'No actions exist' if options[:url].nil? && actions.nil?

    action    = options[:action]
    skip_json = options[:skip_json] || false
    http_verb = options[:http_verb] || options[:action]
    url       = options[:url]
    url     ||= (actions.send(action) or raise Sequencescape::Api::Error, "Cannot perform #{action}")
    raise Sequencescape::Api::Error, 'Cannot perform modification without a URL' if url.blank?

    tap do
      run_validations! or raise Sequencescape::Api::ResourceInvalid, self

      object = skip_json ? {} : self

      api.send(
        http_verb,
        url,
        object,
        Sequencescape::Api::ModifyingHandler.new(self)
      )

      clear_changes_information
    end
  end
  # rubocop:enable Metrics/MethodLength
  private :modify!

  def update_from_json(json, wrapped = false)
    unwrapped = (wrapped ? unwrapped_json(json) : json) || {}
    unwrapped.map(&method(:update_attribute))
  end
  private :update_from_json

  def update_attribute(name_and_value_pair)
    name, value = name_and_value_pair
    case
    when name.to_s == 'actions'                     then update_actions(value)
    when name.to_s == 'uuid'                        then @uuid = (value || @uuid)
    when respond_to?(:"#{name}=", :include_private) then send(:"#{name}=", value)
    else
      debug_log("Unrecognized attribute #{name}")
    end
  end
  private :update_attribute

  def update_actions(actions_from_attributes)
    actions_before_update = @actions

    # We're kind of in a situation where an update of the attributes could be coming from the API
    # or from the client code.  We know that the API will always include 'actions' so we can assume that
    # if it's set then that's what we should use, or we should use the previous actions.
    #
    # TODO: This isn't ideal as it's open to abuse but we can live with it for the moment.
    @actions = actions_from_attributes.nil? ? actions_before_update : OpenStruct.new(actions_from_attributes)
  end
  private :update_actions

  private

  def debug_log(message)
    Rails.logger.debug(message) if defined?(Rails)
  end
end
