require 'spec_helper'

describe 'Retrieving the root S2 URL' do
  context 'with an unauthorised S2 client' do
    is_working_as_an_unauthorised_s2_client

    context "with a specified namespace" do
      context do
#        stub_request_and_response("unauthorised-#{model.to_s.dasherize}-list")
        stub_request_and_response('s2-results-page-1')
        stub_request_and_response('s2-results-page-2')
        stub_request_and_response('s2-results-page-3')

        subject { api.model_a }

        it "makes the correct request for Unauthorised::ModelA" do
          subject.all.each {|p| t = p.name }
        end
      end
    end
  end
end
