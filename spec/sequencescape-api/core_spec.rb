require 'spec_helper'

class Sequencescape::TestModel
  def self.kicker(*args)
    args
  end
end

describe Sequencescape::Api do
  context 'valid initialisation details' do
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
      Sequencescape::Api.connection_factory.should_receive(:create).with('options').and_return(connection)
    end

    context 'checking initialisation' do
      subject { described_class.new('options') }

      it { should respond_to(:test_model) }
      it { subject.test_model.kicker.should == [ subject ] }
    end
  end
end
