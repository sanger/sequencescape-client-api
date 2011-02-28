require 'spec_helper'

describe Sequencescape::Api::ResourceModelProxy do
  before(:each) do 
    @api, @model = double('api'), double('model')
  end

  subject { described_class.new(@api, @model, { :read => 'read URL', :create => 'create URL' }) }

  describe '#respond_to?' do
    it 'checks the proxy methods first' do
      subject.respond_to?(:api, true).should be_true
    end

    context 'methods delegated to the model' do
      it 'delegates to the model if the method is not in the proxy' do
        @model.should_receive(:respond_to?).with(:foo, false).and_return(true)
        subject.respond_to?(:foo).should be_true
      end

      it 'delegates the new method to the model' do
        @model.should_receive(:new).with(@api, :foo).and_return(:result)
        subject.new(:foo).should == :result
      end
    end

    context 'checking methods that are absolutely required' do
      it { subject.respond_to?(:api, true).should be_true     }
      it { subject.respond_to?(:actions, true).should be_true }
      it { subject.respond_to?(:find).should be_true          }
      it { subject.respond_to?(:all).should be_true           }
    end
  end

  describe '#method_missing' do
    it 'sends the API instance as the first parameter to any method' do
      @model.should_receive(:foo).with(@api, :param1, :param2).and_return(:result)
      subject.foo(:param1, :param2).should == :result
    end
  end

  describe '#create!' do
    it 'sends the parameters API wrapped in the appropriate root' do
      @model.should_receive(:json_root).and_return('root')
      @api.should_receive(:create).with(
        'create URL',
        { 'root' => { 'a' => 1, 'b' => 2 } },
        instance_of(Sequencescape::Api::ModifyingHandler)
      )

      object = double('created object')
      object.should_receive(:_run_create_callbacks).and_yield
      @model.should_receive(:new).with(@api, { 'a' => 1, 'b' => 2 }, false).and_return(object)

      subject.create!('a' => 1, 'b' => 2).should == object
    end
  end
end

describe Sequencescape::Api do
  before(:each) do
    @connection = double('connection')
    def @connection.root(handler)
      pseudo_root(&handler.method(:success))
    end
    @connection.should_receive(:pseudo_root).and_yield({})

    described_class.connection_factory = double('connection factory')
    described_class.connection_factory.stub(:create).with(any_args).and_return(@connection)
  end

  subject { described_class.new(:url => 'http://localhost:3000/', :cookie => 'testing') }

  describe '#create' do
    it 'is delegated to the connection' do
      expected = double('expected')
      expected.should_receive(:yielded).with(:result)
      @connection.should_receive(:create).with('URL', 'PARAMS').and_yield(:result)
      subject.create('URL', 'PARAMS', &expected.method(:yielded))
    end
  end
end
