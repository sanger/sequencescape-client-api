module Sequencescape::Api::Actions
  def has_create_action(name = :create!, options = {})
    line = __LINE__ + 1
    class_eval(%Q{
      def #{name}(body = nil, *args)
        body ||= {}
        api.create(actions.#{options[:action] || :create}, { model.json_root => body }, *args) do |json|
          new(json, true)
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
