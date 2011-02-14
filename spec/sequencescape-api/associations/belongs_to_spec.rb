require 'spec_helper'
require 'support/test_association_base'

describe Sequencescape::Api::Associations::BelongsTo do
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
      before(:each) do
        @api.should_receive(:read).with('http://localhost:3000/foo/UUID').and_yield({
          'foo' => {
            'actions' => {
              'read'  => 'http://localhost:3000/foos/UUID'
            },
            'check' => 'definitely going to try'
          }
        })
      end

      its('check') { should == 'definitely going to try' }
    end
  end
end
