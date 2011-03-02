require 'spec_helper'

describe Sequencescape::Api::Resource do
  class TestResourceHelper < described_class

  end

  context 'class methods' do
    subject { TestResourceHelper }

    its(:json_root) { should == 'test_resource_helper' }

    it { should respond_to(:has_create_action) }
    it { should respond_to(:has_update_action) }

    describe '#human_attribute_name("uuid")' do
      it 'is UUID, not Uuid' do
        subject.human_attribute_name(:uuid).should == 'UUID'
      end
    end
  end

  context 'instance methods' do
    before(:each) do
      @api, @attributes = double('api'), {
        'actions'    => { 'update' => 'update URL' },
        'name'       => 'Frank',
        'uuid'       => 'Universally Unique Identifier',
        'created_at' => '05-Feb-2011 15:00',
        'updated_at' => '05-Feb-2011 15:01'
      }
    end

    subject { TestResourceHelper.new(@api, @attributes) }

    # Methods that should be present, even if the attribute is missing
    its(:uuid)       { should == 'Universally Unique Identifier' }
    its(:created_at) { should == Time.parse('05-Feb-2011 15:00') }
    its(:updated_at) { should == Time.parse('05-Feb-2011 15:01') }
    its(:model)      { should == TestResourceHelper              }
    it               { subject.respond_to?(:update_from_json, true).should be_true }

    # Attribute methods
    it         { should respond_to(:name) }
    its(:name) { should == 'Frank' }

    # ActiveModel stuff
    context 'ActiveModel support' do
      its(:to_key)     { should == [ 'Universally Unique Identifier' ] }
      its(:to_param)   { should == 'Universally Unique Identifier' }
      its(:to_model)   { should == subject }

      describe '#persisted?' do
        it 'is true if the UUID is not present' do
          @attributes['uuid'] = 'UUID is set'
          subject.should be_persisted
        end

        it 'is false if the UUID is not present' do
          @attributes.delete('uuid')
          subject.should_not be_persisted
        end
      end
    end

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
        @api.should_receive(:update).with(
          'update URL',
          { 'test_resource_helper' => 'attributes' },
          instance_of(Sequencescape::Api::ModifyingHandler)
        )

        subject.update_attributes!('attributes')
      end
    end
  end
end

describe Sequencescape::Api::ModifyingHandler do
  before(:each) do
    @owner = double('owner')
  end

  subject { described_class.new(@owner) }

  describe '#success' do
    it 'updates the owner JSON' do
      @owner.should_receive(:update_from_json).with('json', true)
      subject.success('json')
    end
  end

  describe '#failure' do
    it 'sets individual field errors' do
      errors = double('errors')
      @owner.stub(:errors).and_return(errors)

      errors.should_receive(:add).with('field1', 'is wrong')
      errors.should_receive(:add).with('field2.subfield', 'is broken')

      lambda do
        subject.failure('content' => { 'field1' => 'is wrong', 'field2.subfield' => 'is broken' })
      end.should raise_error(Sequencescape::Api::ResourceInvalid)
    end

    it 'handles lists of errors on fields' do
      errors = double('errors')
      @owner.stub(:errors).and_return(errors)

      errors.should_receive(:add).with('field1', 'is wrong')
      errors.should_receive(:add).with('field1', 'is broken')

      lambda do
        subject.failure('content' => { 'field1' => [ 'is wrong', 'is broken' ] })
      end.should raise_error(Sequencescape::Api::ResourceInvalid)
    end

    it 'sets object errors' do
      errors = double('errors')
      @owner.stub(:errors).and_return(errors)

      errors.should_receive(:add).with(:base, 'is wrong')

      lambda do
        subject.failure('general' => 'is wrong')
      end.should raise_error(Sequencescape::Api::ResourceInvalid)
    end

    it 'handles lists of object errors' do
      errors = double('errors')
      @owner.stub(:errors).and_return(errors)

      errors.should_receive(:add).with(:base, 'is wrong')
      errors.should_receive(:add).with(:base, 'is broken')

      lambda do
        subject.failure('general' => [ 'is wrong', 'is broken' ])
      end.should raise_error(Sequencescape::Api::ResourceInvalid)
    end
  end
end
