module Sequencescape::Api::Resource::ClassMethods
  def self.extended(base)
    base.class_eval do
      delegate :json_root, :to => 'self.class'
    end
  end

  def json_root
    self.name.demodulize.underscore
  end

  def delegate_to_attributes(*names)
    names.each do |name|
      line = __LINE__ + 1
      class_eval(%Q{
        def #{name}
          attributes[#{name.to_s.inspect}]
        end

        def #{name}=(value)
          #{name}_will_change! unless #{name} == value
          attributes[#{name.to_s.inspect}] = value
        end
      }, __FILE__, line)
    end

    define_attribute_methods(names)
  end
  private :delegate_to_attributes

  def time_attribute(*names)
    names.each do |name|
      line = __LINE__ + 1
      class_eval(%Q{
        def #{name}
          attributes[#{name.to_s.inspect}]
        end

        def #{name}=(value)
          value = value.is_a?(Time) ? value : Time.parse(value.to_s)
          #{name}_will_change! unless #{name} == value
          attributes[#{name.to_s.inspect}] = value
        end
      }, __FILE__, line)
    end

    define_attribute_methods(names)
  end
  private :time_attribute
end
