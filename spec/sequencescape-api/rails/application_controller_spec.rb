require 'spec_helper'
require 'sequencescape-api/rails'

describe Sequencescape::Api::Rails::ApplicationController do
  describe '.included' do
    it 'adds a before_filter' do
      object = Class.new.new    # New object of random class!
      object.class.should_receive(:before_filter).with(:configure_api)
      object.class.should_receive(:attr_reader).with(:api)
      object.class.should_receive(:private).with(:api)
      object.class.send(:include, described_class)
    end
  end

  context 'once included' do
    subject do
      Class.new.new.tap do |object|
        object.class.should_receive(:before_filter).with(any_args)
        object.class.send(:include, described_class)

        object.class.class_eval do
          public :api, :configure_api
        end
      end
    end

    describe '#configure_api' do
      it 'sets the @api instance based on the WTSISignOn cookie' do
        api_class = double('Sequencescape::Api')
        api_class.should_receive(:new).with(:cookie => 'cookie').and_return(:api_instance)
        subject.should_receive(:cookies).and_return('WTSISignOn' => 'cookie')
        subject.should_receive(:api_class).and_return(api_class)

        subject.configure_api

        subject.api.should == :api_instance
      end

      it 'uses the extra options the application defines' do
        api_class = double('Sequencescape::Api')
        api_class.should_receive(:new).with(:cookie => 'cookie', :extra => 'option').and_return(:api_instance)
        subject.should_receive(:cookies).and_return('WTSISignOn' => 'cookie')
        subject.should_receive(:api_class).and_return(api_class)
        subject.should_receive(:extra_options).and_return(:extra => 'option')

        subject.configure_api

        subject.api.should == :api_instance
      end
    end
  end
end
