require 'spec_helper'
require 'support/test_association_base'

describe Sequencescape::Api::Associations::BelongsTo do
  include Sequencescape::ConnectionSupport

  class TestAssociationHelper < TestAssociationBase
    class Foo < TestAssociationBase::Foo
      def loaded
        'yep, loaded!'
      end
    end

    extend Sequencescape::Api::Associations::BelongsTo
    belongs_to :foo, :class_name => self::Foo.name
  end

  before(:each) do
    @api      = double('api')
    @instance = TestAssociationHelper.new(@api)
  end

  describe '.belongs_to' do
    subject { @instance }
    it { should respond_to(:foo) }
  end

  context 'the association itself' do
    subject do
      @instance.attributes = {
        'foo' => {
          'actions' => {
            'read' => 'http://localhost:3000/foo/UUID'
          },
          'name' => 'early loaded name'
        }
      }
      @instance.foo
    end

    context 'check that early attributes are used' do
      it          { should respond_to(:name) }
      its('name') { should == 'early loaded name' }
    end

    context 'accessing the association' do
      it 'reads and processes the JSON' do
        @api.should_receive(:read).with('http://localhost:3000/foo/UUID', is_a_connection_handler)

        # 'check' isn't implemented, but we need it to trigger the retrieval of the object!
        lambda { subject.check }.should raise_error(NameError)
      end
    end
  end
end
