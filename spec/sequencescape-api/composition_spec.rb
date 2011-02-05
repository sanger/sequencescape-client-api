require 'spec_helper'

class Sequencescape::Something
  def initialize(*args)
  end
end

describe Sequencescape::Api::Composition do
  class TestComposedOfHelper
    extend Sequencescape::Api::Composition

    class Thing
      attr_reader :owner, :attributes

      def initialize(owner, attributes)
        @owner, @attributes = owner, attributes
      end

      def ==(other)
        [ :owner, :attributes ].all? { |k| send(k) == other.send(k) }
      end
    end

    def initialize(attributes)
      @attributes = attributes
    end

    def attributes_for(name)
      @attributes[name.to_s]
    end

    composed_of :thing, :class_name => self::Thing.name
    composed_of :something
  end

  before(:each) do
    @instance = TestComposedOfHelper.new({
      'thing'     => 'attributes for thing',
      'something' => 'attributes for something'
    })
  end

  describe '.composed_of' do
    subject { @instance }

    it { should respond_to(:thing)     }
    it { should respond_to(:something) }
  end

  context 'the composed objects' do
    subject { @instance }

    its(:thing)     { should == TestComposedOfHelper::Thing.new(@instance, 'attributes for thing') }
    its(:something) { should be_a(Sequencescape::Something) }
  end
end
