module Sequencescape::Api::Actions
  def self.extended(base)
    base.class_eval do
      extend ClassActionHelpers
      extend InstanceActionHelpers
    end
  end

  module ClassActionHelpers
    # Defines a method that is available on the resource model itself, rather than on an instance of
    # the resource model.
    def has_class_create_action(*args)
      action_module, line = Module.new, __LINE__+1
      action_module.module_eval(%Q{
        def initialize_class_actions(proxy)
          super

          class << proxy
            has_create_action(#{args.map(&:inspect).join(',')})
          end
        end
      }, __FILE__, line)

      extend action_module
    end

    def initialize_class_actions(proxy)
      # Does nothing by default.
    end
    private :initialize_class_actions
  end

  module InstanceActionHelpers
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
      skip_json  = options[:skip_json]||false
      action     = options[:action] || :update

      line = __LINE__ + 1
      class_eval(%Q{
        def #{name}(body = nil)
          update_from_json(body || {}, false)
          modify!(:action => #{action.to_sym.inspect}, :http_verb => #{api_method.to_sym.inspect}, :skip_json => #{skip_json})
        end
      }, __FILE__, line)
    end
  end
end
