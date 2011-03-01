require 'spec_helper'
require 'support/test_association_base'

class Sequencescape::John
  def initialize(*args)
  end
end

describe Sequencescape::Api::Associations::HasMany do
  class TestAssociationHelper < TestAssociationBase
    class Foo < TestAssociationBase::Foo
      def self.callback_runner(*names)
        names.each do |name|
          class_eval(%Q{def _run_#{name}_callbacks ; yield ; end})
        end
      end

      callback_runner :blam

      def run_validations!
        # TODO: hack for the moment, need to test this
        true
      end
    end

    extend Sequencescape::Api::Associations
    has_many :foos, :class_name => self::Foo.name do
      has_create_action :boom, :action => 'blam'
      has_create_action :kerpow
      has_create_action
    end

    has_many :johns, :disposition => :inline

    has_many :bars, :class_name => self::Foo.name, :disposition => :inline
  end

  before(:each) do
    @api      = double('api')
    @instance = TestAssociationHelper.new(@api)
  end

  describe '.has_many' do
    subject { @instance }
    
    it { should respond_to(:foos)  }
    it { should respond_to(:bars)  }
    it { should respond_to(:johns) }
  end

  context 'the association itself' do
    before(:each) do
      @api.stub_chain('capabilities.size_in_pages?').and_return(true)
    end

    context 'where the class_name is unspecified' do
      before(:each) do
        @api.should_receive(:model_name).with(:johns).and_return(Sequencescape::John.name)
      end

      subject do
        @instance.attributes = { 'johns' => [ 'john1' ] }
        @instance.johns
      end

      its(:first) { should be_a(Sequencescape::John) }
    end

    context 'inline has_many association' do
      subject do
        @instance.attributes = {
          'bars' => [
            'foo1',
            'foo2'
          ]
        }
        @instance.bars
      end

      it { should respond_to(:all)  }
      it { should respond_to(:find) }
      its(:size) { should == 2 }

      its(:to_a) do
        should == [
          TestAssociationHelper::Foo.new(@api, 'foo1', false),
          TestAssociationHelper::Foo.new(@api, 'foo2', false)
        ]
      end

      it 'gets reloaded if the record is updated' do
        @instance.update_attributes!('bars' => [ 'foo3', 'foo4' ])
        @instance.bars.to_a.should == [
          TestAssociationHelper::Foo.new(@api, 'foo3', false),
          TestAssociationHelper::Foo.new(@api, 'foo4', false)
        ]
      end
    end

    context 'normal has_many association' do
      subject do
        @instance.attributes = {
          'foos' => {
            'actions' => { 
              'read'   => 'http://localhost:3000/foos',
              'blam'   => 'explodes in your face',
              'create' => 'creation URL'
            }
          }
        }
        @instance.foos
      end

      it { should respond_to(:all)  }
      it { should respond_to(:find) }

      context 'described actions' do
        {
          :boom    => 'explodes in your face',
          :kerpow  => 'creation URL',
          :create! => 'creation URL'
        }.each do |method, url|
          it { should respond_to(method) }

          it 'calls the API to create using the correct URL' do
            @api.should_receive(:create).with(
              url,
              { 'foo' => { 'key' => 'go' } },
              instance_of(::Sequencescape::Api::ModifyingHandler)
            )

            subject.send(method, 'key' => 'go')
          end
        end
      end

      context 'accessing the association' do
        it 'builds the association on demand' do
          @api.should_receive(:read).with('http://localhost:3000/foos', instance_of(::Sequencescape::Api::FinderMethods::AllHandler))
          subject.all
        end

        it 'gets reloaded if the record is updated' do
          @instance.update_attributes!(
            'foos' => {
              'actions' => { 
                'read' => 'http://localhost:3000/foos_have_mooved'
              }
            }
          )

          @api.should_receive(:read).with('http://localhost:3000/foos_have_mooved', instance_of(::Sequencescape::Api::FinderMethods::AllHandler))
          @instance.foos.all
        end
      end
    end
  end
end

describe Sequencescape::Api::Resource do
  describe '#attributes_for' do
    before(:each) do
      @api = double('api')
    end

    subject do 
      Sequencescape::Api::Resource.new(@api, { 
        'bar' => 'element',
        'root' => { 'leaf' => "blowin' in the wind" }
      })
    end

    it 'makes its API instance available' do
      subject.respond_to?(:api, true).should be_true
    end

    it 'raises JsonError if the attributes cannot be found' do
      lambda { subject.attributes_for('foos') }.should raise_error(Sequencescape::Api::JsonError)
    end

    it 'returns the JSON for a direct JSON element' do
      subject.attributes_for('bar').should == 'element'
    end

    it 'returns the JSON for a path JSON element' do
      subject.attributes_for('root.leaf').should == "blowin' in the wind"
    end
  end
end
