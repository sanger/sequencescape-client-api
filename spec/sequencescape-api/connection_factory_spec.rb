require 'spec_helper'

describe Sequencescape::Api::ConnectionFactory do
  describe '.create' do
    def should_error_with_these_options(options)
      lambda { described_class.create(options) }.should raise_error(Sequencescape::Api::Error)
    end

    required_options = [ :cookie, :url ]
    required_options.each do |option|
      # Generate a set of options that will not cause another error, but skip the option we're testing.
      other_options = Hash[(required_options - [ option ]).map { |o| [ o, 'value' ] }]

      it "errors if no #{option.inspect} is set" do
        should_error_with_these_options(other_options)
      end

      it "errors if #{option.inspect} is nil" do
        should_error_with_these_options(other_options.merge(option => nil))
      end

      it "errors if #{option.inspect} is blank" do
        should_error_with_these_options(other_options.merge(option => ''))
      end
    end

    context 'default_url has been set' do
      before(:each) do
        described_class.default_url = 'default url'
      end

      it 'uses the default_url if no :url specified' do
        described_class.create(:cookie => 'foo').send(:url).should == 'default url'
      end

      it 'the specified URL overrides default_url' do
        described_class.create(:cookie => 'foo', :url => 'i want this one').send(:url).should == 'i want this one'
      end
    end
  end

  describe 'connection instance behaviour' do
    context 'normal behaviour' do
      subject do 
        described_class.create(:url => 'http://localhost:3000/', :cookie => 'testing')
      end

      describe '#url_for_uuid' do
        it 'combines the URL specified with the UUID' do
          subject.url_for_uuid('UUID').should == 'http://localhost:3000/UUID'
        end
      end

      describe '#root' do
        it 'reads the JSON from the root URL' do
          handler = double('handler')
          subject.should_receive(:read).with('http://localhost:3000/', handler)
          subject.root(handler)
        end
      end
    end

    shared_examples_for 'modifies resource' do |method, action, success_code|
      it 'errors if the content is not JSON' do
        stub_request(action.to_sym, 'http://localhost:3000/action').with(
          :headers => {
            'Cookie' => 'WTSISignOn=testing',
            'Accept' => 'application/json'
          }.merge(headers),
          :body => %Q{JSON!}
        ).to_return(
          :status  => 201,
          :headers => { 'Content-Type' => 'text/html' },
          :body    => %Q{{ "b" : 2 }}
        )

        expected = double('expected')

        body = double('body')
        body.should_receive(:to_json).and_return('JSON!')

        lambda do
          subject.send(method, 'http://localhost:3000/action', body, expected)
        end.should raise_error(described_class::Actions::ServerError)
      end

      {
        success_code => :success,
        401          => :unauthenticated,
        404          => :missing,
        422          => :failure
      }.each do |status, handler_method|
        it "handles HTTP status code #{status} by calling #{handler_method}" do
          stub_request(action.to_sym, 'http://localhost:3000/action').with(
            :headers => {
              'Cookie' => 'WTSISignOn=testing',
              'Accept' => 'application/json'
            }.merge(headers),
            :body => %Q{JSON!}
          ).to_return(
            :status  => status,
            :headers => { 'Content-Type' => 'application/json' },
            :body    => %Q{{ "b" : 2 }}
          )

          expected = double('expected')
          expected.should_receive(handler_method).with({ 'b' => 2 })

          body = double('body')
          body.should_receive(:to_json).and_return('JSON!')

          subject.send(method, 'http://localhost:3000/action', body, expected)
        end
      end
    end

    shared_examples_for 'it creates, reads and updates' do
      describe '#read' do
        {
          200 => :success,
          401 => :unauthenticated,
          404 => :missing
        }.each do |status, handler_method|
          it "handles HTTP status code #{status} by calling #{handler_method}" do
            stub_request(:get, 'http://localhost:3000/').with(
              :headers => {
                'Cookie' => 'WTSISignOn=testing',
                'Accept' => 'application/json'
              }.merge(headers)
            ).to_return(
              :status  => status,
              :headers => { 'Content-Type' => 'application/json' },
              :body    => %Q{{ "a" : 1 }}
            )

            expected = double('expected')
            expected.should_receive(handler_method).with({ 'a' => 1 })

            subject.read('http://localhost:3000/', expected)
          end
        end

        it 'errors if the content is not JSON' do
          stub_request(:get, 'http://localhost:3000/').with(
            :headers => {
              'Cookie' => 'WTSISignOn=testing',
              'Accept' => 'application/json'
            }.merge(headers)
          ).to_return(
            :status  => 200,
            :headers => { 'Content-Type' => 'text/html' }
          )

          expected = double('expected')

          lambda do
            subject.read('http://localhost:3000/', expected)
          end.should raise_error(described_class::Actions::ServerError)
        end
      end

      describe '#create' do
        it_behaves_like('modifies resource', :create, :post, 201)
      end

      describe '#update' do
        it_behaves_like('modifies resource', :update, :put, 200)
      end
    end

    context 'HTTP interaction' do
      context 'authorised behaviour' do
        subject do 
          described_class.create(:url => 'http://localhost:3000/', :cookie => 'testing', :authorisation => 'knock-knock')
        end

        let(:headers) do
          { 'X-Sequencescape-Client-ID' => 'knock-knock' }
        end

        it_should_behave_like 'it creates, reads and updates'
      end

      context 'unauthorised behaviour' do
        subject do 
          described_class.create(:url => 'http://localhost:3000/', :cookie => 'testing')
        end

        let(:headers) do
          { }
        end

        it_should_behave_like 'it creates, reads and updates'
      end
    end
  end
end
