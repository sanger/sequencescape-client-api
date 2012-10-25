require 'time'
require 'active_support/core_ext/string/conversions'

module Sequencescape::Api::Resource::Attributes
  def self.extended(base)
    base.class_eval do
      include InstanceMethods
      class_inheritable_reader :defined_attributes
      write_inheritable_attribute(:defined_attributes, Set.new)
    end
  end

  module InstanceMethods
    def is_attribute?(name)
      defined_attributes.include?(name.to_sym)
    end

    def eager_loaded_attribute?(name)
      is_attribute?(name) and attributes.key?(name.to_s)
    end
  end

  module SizeCalculator
    def self.included(base)
      base.class_eval { attribute_accessor :dimension }
    end

    def size
      dimension["number_of_rows"]*dimension["number_of_columns"]
    end
  end

  def generate_attribute_reader(*names)
    options    = names.extract_options!
    conversion = options[:conversion].blank? ? nil : "try(#{options[:conversion].to_sym.inspect})"

    names.each do |name|
      defined_attributes << name.to_sym
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
    extend_attribute_methods(names)
  end
  private :generate_attribute_reader

  def generate_attribute_writer(*names)
    options = names.extract_options!

    names.each do |name|
      defined_attributes << name.to_sym

      line = __LINE__ + 1
      class_eval(%Q{
        def #{name}=(value)
          #{name}_will_change! if not attributes.key?(#{name.to_s.inspect}) or #{name} != value
          attributes[#{name.to_s.inspect}] = value
        end
      }, __FILE__, line)
    end
    extend_attribute_methods(names)
  end
  private :generate_attribute_writer

  def attribute_reader(*names)
    attribute_accessor(*names)
    class_eval { names.map { |m| private :"#{m}=" } }
  end
  private :attribute_reader

  def attribute_writer(*names)
    attribute_accessor(*names)
    class_eval { names.map(&method(:private)) }
  end
  private :attribute_writer

  def attribute_accessor(*names)
    generate_attribute_reader(*names)
    generate_attribute_writer(*names)
  end
  private :attribute_accessor

  def extend_attribute_methods(names)
    @attribute_methods_generated = false
    define_attribute_methods(names)
  end
  private :extend_attribute_methods
end
