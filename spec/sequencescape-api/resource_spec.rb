require 'spec_helper'

describe Sequencescape::Api::Resource do
  class TestResourceHelper < described_class

  end

  context 'class methods' do
    subject { TestResourceHelper }

    its(:json_root) { should == 'test_resource_helper' }

    it { should respond_to(:has_create_action) }
    it { should respond_to(:has_update_action) }
  end

  context 'instance methods' do
    subject do
      @api, @attributes = double('api'), {
        'actions' => { 'update' => 'update URL' },
        'name'    => 'Frank',
        'uuid'    => 'Universally Unique Identifier'
      }
      TestResourceHelper.new(@api, @attributes)
    end

    # Methods that should be present, even if the attribute is missing
    it          { should respond_to(:uuid)                  }
    its(:uuid)  { should == 'Universally Unique Identifier' }
    it          { should respond_to(:created_at)            }
    it          { should respond_to(:updated_at)            }
    its(:model) { should == TestResourceHelper              }
    it          { subject.respond_to?(:update_from_json, true).should be_true }

    # Attribute methods
    it         { should respond_to(:name) }
    its(:name) { should == 'Frank' }

    describe '#as_json' do
      it 'returns the UUID' do
        subject.send(:as_json).should == subject.uuid
      end
    end

    describe '#update_from_json' do
      it 'changes content if the JSON is updated' do
        subject.send(:update_from_json, { 'name' => 'Bert' })
        subject.name.should == 'Bert'
      end
    end

    describe '#update_attributes!' do
      it 'performs an API update, updating the attributes with the response' do
        subject.should_receive(:update_from_json).with('JSON', true)
        @api.should_receive(:update).with('update URL', { 'test_resource_helper' => 'attributes' }).and_yield('JSON')

        subject.update_attributes!('attributes').should == subject
      end
    end
  end
end
