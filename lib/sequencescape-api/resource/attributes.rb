require 'time'
require 'active_support/core_ext/string/conversions'

module Sequencescape::Api::Resource::Attributes
  def attribute_reader(*names)
    options    = names.extract_options!
    conversion = options[:conversion].blank? ? nil : "try(#{options[:conversion].to_sym.inspect})"

    names.each do |name|
      converted = [ "#{name}_before_type_cast", conversion ].compact.join('.')

      line = __LINE__ + 1
      class_eval(%Q{
        def #{name}
          #{converted}
        end

        def #{name}_before_type_cast
          attributes[#{name.to_s.inspect}]
        end
      }, __FILE__, line)
    end
    define_attribute_methods(names)
  end
  private :attribute_reader

  def attribute_writer(*names)
    options = names.extract_options!

    names.each do |name|
      line = __LINE__ + 1
      class_eval(%Q{
        def #{name}=(value)
          #{name}_will_change! unless #{name} == value
          attributes[#{name.to_s.inspect}] = value
        end
      }, __FILE__, line)
    end
    define_attribute_methods(names)
  end
  private :attribute_writer

  def attribute_accessor(*names)
    attribute_reader(*names)
    attribute_writer(*names)
  end
  private :attribute_accessor

  def extend_attribute_methods(names)
    @attribute_methods_generated = false
    define_attribute_methods(names)
  end
  private :extend_attribute_methods
end
