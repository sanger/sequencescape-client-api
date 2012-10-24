require 'spec_helper'

describe 'Characterising a resource instance' do
  is_working_as_an_unauthorised_client

  subject { api.model_d.find('UUID') }

  context 'when it is found' do
    stub_request_from('retrieve-model') { response('model-d-instance') }

    its(:size) { should == 96 }

  end
end