module Sequencescape::Api::Actions
  def has_create_action(name = :create!, options = {})
    action = options[:action] || :create

    line = __LINE__ + 1
    class_eval(%Q{
      def #{name}(attributes = nil)
        new(attributes || {}, false).tap do |object|
          object.save!(:url => actions.#{action})
        end
      end
    }, __FILE__, line)
  end

  def has_update_action(name, options = {})
    api_method = options[:verb] == :create ? :create : :update
    action     = options[:action] || :update

    line = __LINE__ + 1
    class_eval(%Q{
      def #{name}(body = nil)
        update_from_json(body || {}, false)
        modify!(:action => #{action.to_sym.inspect}, :http_verb => #{api_method.to_sym.inspect})
      end
    }, __FILE__, line)
  end
end
