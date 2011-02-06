require 'spec_helper'

module Kick
  class TestModel
    def self.kicker(*args)
      args
    end
  end
end

describe Sequencescape::Api do
  context '#initialize' do
    before(:each) do
      connection = double('connection')
      connection.should_receive(:root).and_yield({
        'test_models' => {
          'actions' => {
            'create' => 'http://localhost:3000/create',
            'read'   => 'http://localhost:3000/read'
          }
        }
      })

      Sequencescape::Api.connection_factory = double('connection factory')
      Sequencescape::Api.connection_factory.should_receive(:create).with(:our => 'options').and_return(connection)
    end

    it 'passes the options to the connection factory' do
      described_class.new(:our => 'options')
    end

    context 'with :namespace' do
      subject { described_class.new(:namespace => ::Kick, :our => 'options') }
      it { should respond_to(:test_model) }
      it { subject.test_model.kicker.should == [ subject ] }
    end
  end
end
