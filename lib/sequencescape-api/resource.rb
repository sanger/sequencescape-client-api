require 'sequencescape-api/associations'
require 'sequencescape-api/actions'

require 'ostruct'

module Sequencescape
  class Api
    class JsonError
      def initialize(path)
        super("Cannot find the JSON attributes for #{path.inspect}")
      end
    end

    class Resource
      extend Sequencescape::Api::Associations
      extend Sequencescape::Api::Actions

      def self.json_root
        self.name.demodulize.underscore
      end
      delegate :json_root, :to => 'self.class'

      def self.delegate_to_attributes(*names)
        names.each do |name|
          line = __LINE__ + 1
          class_eval(%Q{
            def #{name}
              attributes[#{name.to_s.inspect}]
            end
          }, __FILE__, line)
        end
      end

      attr_reader :api, :actions, :attributes
      private :api, :actions, :attributes
      delegate_to_attributes :uuid, :created_at, :updated_at
      alias_method(:model, :class)

      def initialize(api, json = nil, wrapped = false)
        @api = api
        update_from_json(json, wrapped)
      end

      def update_attributes!(attributes)
        self.tap do
          api.update(actions.update, { json_root => attributes }) do |json|
            update_from_json(json, true)
          end
        end
      end

      def respond_to?(name, include_private = false)
        super || attributes.key?(name.to_s)
      end

      def method_missing(name, *args, &block)
        return super unless attributes.key?(name.to_s)
        return super unless args.empty?
        attributes[name.to_s]
      end
      protected :method_missing

      def as_json(options = nil)
        uuid
      end
      protected :as_json

      def update_from_json(json, wrapped = false)
        @attributes = (wrapped ? unwrapped_json(json) : json) || {}
        @actions    = OpenStruct.new(@attributes.delete('actions'))
      end
      private :update_from_json

      def unwrapped_json(json)
        json[(json.keys - [ 'uuids_to_ids' ]).first]
      end
      private :unwrapped_json
    end
  end
end
