module Sequencescape::Api::Actions
  def has_create_action(*args)
    options      = args.extract_options!
    name         = args.first || :create!

    action       = options[:action] || :create
    result_class = 'self'
    result_class = "api.#{options[:resource]}" if options[:resource]

    line = __LINE__ + 1
    class_eval(%Q{
      def #{name}(attributes = nil)
        url = actions.try(#{action.to_sym.inspect}) or
          raise Sequencescape::Api::Error, "Cannot perform #{action} without an URL"

        #{result_class}.new(attributes || {}, false).tap do |object|
          object.save!(:url => url)
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
