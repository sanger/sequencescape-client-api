module Sequencescape::Api::Associations::HasMany::SharedInline

  def all
    @objects
  end

  def self.included(base)
    base.class_eval %Q{
    def each_page(&block)
      yield(@objects)
    end
    }
  end

  def new(json, &block)
    super(json, false, &block)
  end
  private :new

  # We are changed if any of our objects have been changed.
  def changed?
    @objects.any?(&:changed?)
  end

  def update_from_json(json)
    case
    when json.is_a?(Array) then @objects = json.map(&method(:new))
    when json.is_a?(Hash)  then update_objects_from_json(json)
    else raise StandardError, "Cannot handle has_many JSON: #{json.inspect}"
    end
  end
  private :update_from_json

end