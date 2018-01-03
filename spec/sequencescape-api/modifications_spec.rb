require 'spec_helper'

shared_examples_for 'errors on both client and server' do |action, request_contract|
  context 'may be invalid on the client side' do
    it 'raises an error' do
      lambda do
        target.__send__(action, :attribute_validated_at_client => 'please error')
      end.should raise_error(Sequencescape::Api::ResourceInvalid)
    end

    it 'includes the error on the field' do
      begin
        target.__send__(action, :attribute_validated_at_client => 'please error')
      rescue Sequencescape::Api::ResourceInvalid => exception
        exception.resource.errors[:attribute_validated_at_client].should == [ 'cannot be set' ]
      end
    end
  end

  context 'may be invalid on the server side' do
    stub_request_from(request_contract) { response('model-c-invalid-attribute') }

    it 'raises an error' do
      lambda do
        target.__send__(action, :attribute_validated_at_server => 'please error')
      end.should raise_error(Sequencescape::Api::ResourceInvalid)
    end

    it 'includes the error on the field' do
      begin
        target.__send__(action, :attribute_validated_at_server => 'please error')
      rescue Sequencescape::Api::ResourceInvalid => exception
        exception.resource.errors[:attribute_validated_at_server].should == [ 'cannot be set' ]
      end
    end
  end
end

describe 'Creating a resource' do
  is_working_as_an_unauthorised_client

  let(:target) { api.model_c }

  context do
    it_behaves_like 'errors on both client and server', :create!, 'create-invalid-resource'
  end

  context do
    stub_request_from('create-model-c') { response('model-c-instance-created') }

    subject do
      target.create!(:changes_during_update => 'sent from client', :remains_same_during_update => 'from JSON')
    end

    its(:changes_during_update)      { should == 'set during create' }
    its(:remains_same_during_update) { should == 'and this was too' }
  end

  context 'with its associations' do
    context 'belongs_to' do
      it 'takes an object and converts it to UUID'
    end
    context 'has_many disposition: :inline' do
      stub_request_from('create-model-c-has-many-inline') { response('model-c-instance-created') }

      it 'takes an array of objects and converts them to UUID'
      it 'assumes an array of strings are UUIDs' do
        target.create!(:model_bs => ['model-b-uuids'])
      end
      it 'raises if not given an enumerable'
    end

    context 'has_many disposition: :inline nested' do
      stub_request_from('create-model-c-has-many-inline-nested') { response('model-c-instance-created') }

      it 'takes an array of objects and converts them to UUID'
      it 'assumes an array of strings are UUIDs' do
        target.create!(:model_bs => [{ "test_attribute" => "test_value" }])
      end
      it 'raises if not given an enumerable'
    end

    context 'has_many' do
      stub_request_from('create-model-c-has-many') { response('model-c-instance-created') }

      it 'takes an array of objects and converts them to UUID'
      it 'assumes an array of strings are UUIDs' do
        target.create!(:model_as => ['model-a-uuids'])
      end
      it 'raises if not given an enumerable'
    end
  end

  context 'through an association' do
    context 'has_many' do
      it 'ensures that the instance becomes part of the association'
    end
  end
end

describe 'Updating a resource' do
  is_working_as_an_unauthorised_client

  stub_request_from('retrieve-model') { response('model-c-instance') }
  let(:target) { api.model_c.find('UUID') }

  context do
    it_behaves_like 'errors on both client and server', :update_attributes!, 'update-invalid-resource'
  end

  shared_examples_for 'it is updating a resource' do
    subject { target }

    its(:changes_during_update)      { should == 'changed' }
    its(:remains_same_during_update) { should == 'stays the same' }
  end

  context '#update_attributes!' do
    stub_request_from('update-model-c') { response('model-c-instance-updated') }

    before(:each) do
      subject.update_attributes!(
        :changes_during_update => 'sent from client',
        :remains_same_during_update => 'from JSON',
        :write_only => 'has been set'
      )
    end

    it_behaves_like 'it is updating a resource'
  end

  context '#save!' do
    stub_request_from('update-model-c') { response('model-c-instance-updated') }

    before(:each) do
      subject.changes_during_update      = 'sent from client'
      subject.remains_same_during_update = 'from JSON'
      subject.write_only                 = 'has been set'
      subject.save!
    end

    it_behaves_like 'it is updating a resource'
  end

  context 'specifically its associations' do
    context 'belongs_to' do
      it 'takes an object and converts it to UUID'
    end
    context 'has_many' do
      it 'takes an array of objects and converts them to UUID'
      it 'assumes an array of strings are UUIDs'
      it 'raises if not given an enumerable'
    end
  end
end

describe 'Updating a resource through an association' do
  is_working_as_an_unauthorised_client

  context 'belongs_to' do
    it 'handles individual attribute changes'
    it 'handles update_attributes!'
  end

  context 'has_many' do
    it 'handles individual attribute changes'
  end
end

