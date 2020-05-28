# frozen_string_literal: true

require 'spec_helper'

describe 'Finding a resource instance' do
  is_working_as_an_unauthorised_client

  subject { api.model_c.find('UUID') }

  context 'when it is not found' do
    stub_request_from('retrieve-model') { response('resource-not-found') }

    it 'raises an exception' do
      -> { subject }.should raise_error(Sequencescape::Api::ResourceNotFound)
    end
  end

  context 'when it is found' do
    stub_request_from('retrieve-model') { response('model-c-instance') }

    its(:changes_during_update)      { should == 'from JSON' }
    its(:remains_same_during_update) { should == 'from JSON' }
  end
end

describe 'Finding resource instances' do
  is_working_as_an_unauthorised_client

  stub_request_and_response('results-page-1')
  stub_request_and_response('results-page-2')
  stub_request_and_response('results-page-3')

  subject { api.page.all }

  it_behaves_like 'a paged result'
end
