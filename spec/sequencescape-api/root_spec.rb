require 'spec_helper'

describe 'Handling authentication issues' do
  stub_request_from('retrieve-root-with-an-unauthorised-client') { response('client-fails-authentication') }

  subject { Sequencescape::Api.new(:url => 'http://localhost:3000/', :cookie => 'single-sign-on-cookie') }

  it 'raises an exception' do
    lambda { subject }.should raise_error(Sequencescape::Api::UnauthenticatedError)
  end
end

describe 'Retrieving the root URL' do
  context 'with an unauthorised client' do
    is_working_as_an_unauthorised_client

    context 'with no namespace' do
      subject { Sequencescape::Api.new(:url => 'http://localhost:3000/', :cookie => 'single-sign-on-cookie') }

      Unauthorised::MODELS_THROUGH_API.each do |model|
        it "provides the #{model} through the API instance" do
          subject.should respond_to(model.to_sym)
        end

        it "errors because Sequencescape::#{model.to_s.classify} is not defined" do
          # Note: Using a regex as > Ruby 2.3 'DidYouMean' changes the error message slightly.
          lambda { subject.send(model.to_sym) }.should raise_error(NameError, /uninitialized constant Sequencescape::#{model.to_s.classify}/)
        end
      end
    end

    context "with a specified namespace" do
      Unauthorised::MODELS_THROUGH_API.each do |model|
        context do
          stub_request_and_response("unauthorised-#{model.to_s.dasherize}-list")

          subject { api.send(model) }

          it "makes the correct request for Unauthorised::#{model.to_s.classify}" do
            subject.all
          end
        end
      end
    end
  end

  context 'with an authorised client' do
    is_working_as_an_authorised_client

    subject { api }

    [ :model_c, :model_d ].each do |model|
      it "provides the #{model} through the API instance" do
        subject.should respond_to(model.to_sym)
      end
    end
  end
end
