class TestAssociationBase
  class Foo
    FIELDS = [ :api, :json, :wrapped ]
    attr_reader :api, :json, :wrapped

    def initialize(api, json, wrapped = false)
      @api, @json, @wrapped = api, json, wrapped
    end

    def ==(value)
      FIELDS.map(&method(:send)) == FIELDS.map(&value.method(:send))
    end

    def self.json_root
      'foo'
    end

    def method_missing(name, *args, &block)
      json = @wrapped ? @json.fetch('foo', {}) : @json
      (args.empty? and json.key?(name.to_s)) ? json[name.to_s] : super
    end
  end

  attr_accessor :attributes
  attr_reader :api
  private :api

  def initialize(api)
    @api, @attributes = api, {}
  end

  def attributes_for(name)
    @attributes[name.to_s]
  end

  def update_attributes!(attributes)
    @attributes = attributes
  end
end
