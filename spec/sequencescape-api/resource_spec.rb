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
        'actions'    => { 'update' => 'update URL' },
        'name'       => 'Frank',
        'uuid'       => 'Universally Unique Identifier',
        'created_at' => '05-Feb-2011 15:00',
        'updated_at' => '05-Feb-2011 15:01'
      }
      TestResourceHelper.new(@api, @attributes)
    end

    # Methods that should be present, even if the attribute is missing
    its(:uuid)       { should == 'Universally Unique Identifier' }
    its(:created_at) { should == Time.parse('05-Feb-2011 15:00') }
    its(:updated_at) { should == Time.parse('05-Feb-2011 15:01') }
    its(:model)      { should == TestResourceHelper              }
    it               { subject.respond_to?(:update_from_json, true).should be_true }

    # Attribute methods
    it         { should respond_to(:name) }
    its(:name) { should == 'Frank' }

    describe '#eql?' do
      it 'is equal to itself!' do
        subject.should be_eql(subject)
      end

      it 'is equal when UUIDs are equal' do
        subject.should be_eql(Object.new.tap { |o| def o.uuid ; 'Universally Unique Identifier' ; end })
      end

      it 'is not equal when the UUIDs are different' do
        subject.should_not be_eql(Object.new.tap { |o| def o.uuid ; 'Not the same!' ; end })
      end

      it 'is not equal otherwise' do
        subject.should_not be_eql(Object.new)
      end
    end

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
