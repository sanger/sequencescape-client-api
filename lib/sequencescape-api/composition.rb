module Sequencescape::Api::Composition
  module Target
    def self.included(base)
      base.class_eval do
        include Sequencescape::Api::Resource::ActiveModel
        extend Sequencescape::Api::Resource::Attributes
        extend Sequencescape::Api::Composition
      end
    end

    def initialize(owner, attributes)
      @owner, @attributes = owner, attributes
    end

    attr_reader :attributes
    private :attributes

    def attributes_for(name)
      attributes[name]
    end
    private :attributes_for
  end

  def composed_of(name, options = {})
    composed_class_name = options[:class_name] || name

    line = __LINE__ + 1
    class_eval(%Q{
      def #{name}
        api.model(#{composed_class_name.inspect}).new(self, attributes_for(#{name.to_s.inspect}))
      end

      def #{name}=(attributes)
        @attributes[#{name.to_s.inspect}] = attributes
      end
    }, __FILE__, line)
  end
end
