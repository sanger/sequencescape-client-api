module Sequencescape::Api::Actions
  def has_create_action(name = :create!, options = {})
    action = options[:action] || :create

    line = __LINE__ + 1
    class_eval(%Q{
      def #{name}(attributes = nil, *args)
        attributes ||= {}
        new(attributes, false).tap do |object|
          object.send(:_run_create_callbacks) do
            api.create(actions.#{options[:action] || :create}, { model.json_root => attributes }) do |json|
              object.send(:update_from_json, json, true)
            end
          end
        end
      end
    }, __FILE__, line)
  end

  def has_update_action(name, options = {})
    api_method = options[:verb] == :create ? :create : :update

    line = __LINE__ + 1
    class_eval(%Q{
      def #{name}(body = nil, *args)
        body ||= {}
        api.#{api_method}(actions.#{options[:action] || :update}, { model.json_root => body }, *args) do |json|
          update_from_json(json, true)
        end
      end
    }, __FILE__, line)
  end
end
