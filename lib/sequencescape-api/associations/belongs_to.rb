require 'sequencescape-api/associations/base'

module Sequencescape
  class Api
    module Associations
      module BelongsTo
        class AssociationProxy < Sequencescape::Api::Associations::Base
          def respond_to?(name, include_private = false)
            case
            when super                                     then true # One of our methods ...
            when !is_object_loaded? && is_attribute?(name) then true # ... or an early attribute and no object ...
            else is_object_method?(name, include_private)            # ... or force the object load and check
            end
          end

          def method_missing(name, *args, &block)
            return @attributes[name.to_s] if !is_object_loaded? and is_attribute?(name) and args.empty?
            object.send(name, *args, &block)
          end

          def is_attribute?(name)
            @attributes.key?(name.to_s)
          end
          private :is_attribute?

          def is_object_method?(name, include_private)
            object.respond_to?(name, include_private)
          end
          private :is_object_method?

          def is_object_loaded?
            not @object.nil?
          end
          private :is_object_loaded?

          def object
            @object ||= api.read(actions.read) do |json|
              new(json, true)
            end
          end
          private :object
        end

        def belongs_to(association, options, &block)
          association = association.to_sym

          line = __LINE__ + 1
          class_eval(%Q{
            def #{association}(reload = false)
              associations[#{association.inspect}]   = nil if !!reload
              associations[#{association.inspect}] ||= AssociationProxy.new(self, #{association.inspect}, #{options.inspect})
              associations[#{association.inspect}]
            end
          }, __FILE__, line)
        end
      end
    end
  end
end
