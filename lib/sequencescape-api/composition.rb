module Sequencescape::Api::Composition
  def composed_of(name, options = {})
    composed_class_code = options[:class_name] || "api.model_name(#{name.inspect}).constantize"

    line = __LINE__ + 1
    class_eval(%Q{
      def #{name}
        #{composed_class_code}.new(self, attributes_for(#{name.to_s.inspect}))
      end

      def #{name}=(attributes)
        @attributes[#{name.to_s.inspect}] = attributes
      end
    }, __FILE__, line)
  end
end
