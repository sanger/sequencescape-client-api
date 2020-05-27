module Sequencescape::Api::Associations::Base::InstanceMethods
  def self.included(base)
    base.class_eval do
      class_attribute :association, :options
      class_attribute :default_attributes_if_missing, :instance_writer => false

      attr_reader :model
      delegate :read_timeout, :to => :@owner
      private :model

      def api(*args, &block)
        # TODO: Consider updating
        @owner.__send__(:api, *args, &block)
      end
      private :api
    end
  end

  def initialize(owner, json = nil)
    @owner      = owner
    @_attributes_ = json.nil? ? owner.attributes_for(association, default_attributes_if_missing) : attributes_from(json)
    @model      = api.model(options[:class_name] || association)
  end

  def new(*args, &block)
    model.new(api, *args, &block)
  end
  private :new

  # We can be passed several different types of information as though it was JSON:
  #
  # 1. It could be a string, in which case we'll assume it's a UUID
  # 2. It could be an instance of the model we're expected to reference, in which case we take it's attributes
  # 3. It could be an association like us that references the same model, in which case we take it's attributes
  # 4. Finally it could actually be the JSON!
  def attributes_from(json)
    case
    when json.is_a?(String)                                 then { uuid: json, uuid_only: true }
    when json.is_a?(Hash)                                   then json
    when json.respond_to?(:map)                             then json.map(&method(:attributes_from))
    when json.is_a?(Sequencescape::Api::Resource)           then json.as_json(:force => true, :action => :update, :root => false, :uuid => true)
    when json.is_a?(Sequencescape::Api::Associations::Base) then json.as_json(:force => true, :action => :update)
    else raise json.inspect
    end
  end
  private :attributes_from

  def proxy_present?
    true
  end
end

class NilClass
  def proxy_present?
    false
  end
end
