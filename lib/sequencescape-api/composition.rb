module Sequencescape::Api::Composition
  module Target
    def self.included(base)
      base.class_eval do
        include Sequencescape::Api::Resource::ActiveModel
        extend Sequencescape::Api::Resource::Attributes

        extend  Sequencescape::Api::Resource::Groups
        include Sequencescape::Api::Resource::Groups::Json
      end
    end

    def initialize(owner, attributes)
      @owner, @attributes = owner, attributes
      attributes.each { |k,v| send(:"#{k}=", v) }
    end

    attr_reader :attributes
    private :attributes
  end

  def composed_of(name, options = {})
    composed_class_name = options[:class_name] || name

    line = __LINE__ + 1
    class_eval(%Q{
      def #{name}
        return nil unless attributes_for?(#{name.to_s.inspect})
        api.model(#{composed_class_name.inspect}).new(self, attributes_for(#{name.to_s.inspect}))
      end

      def #{name}=(attributes)
        @attributes[#{name.to_s.inspect}] = attributes
      end
    }, __FILE__, line)
  end
end
