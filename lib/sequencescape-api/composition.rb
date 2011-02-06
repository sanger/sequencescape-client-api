module Sequencescape::Api::Composition
  def composed_of(name, options = {})
    line = __LINE__ + 1
    class_eval(%Q{
      def #{name}
        composed_class = (#{options[:class_name].inspect} || api.model_name(#{name.inspect})).constantize
        composed_class.new(self, attributes_for(#{name.to_s.inspect}))
      end
    }, __FILE__, line)
  end
end
