require 'spec_helper'

describe Sequencescape::Api::FinderMethods do
  class FinderTestHelper
    extend Sequencescape::Api::FinderMethods

    attr_reader :api, :json, :wrapped

    def initialize(json, wrapped)
      @json, @wrapped = json, wrapped
    end

    class_inheritable_accessor :api
  end

  before(:each) do
    FinderTestHelper.api = double('api')
  end

  describe '#find' do
    before(:each) do
      FinderTestHelper.api.should_receive(:read_uuid).with('UUID').and_yield('json')
    end

    subject { FinderTestHelper.find('UUID') }

    its(:api)     { should == FinderTestHelper.api }
    its(:json)    { should == 'json' }
    its(:wrapped) { should be_true }
  end

  describe '#all' do
    before(:each) do
      FinderTestHelper.stub_chain('actions.read').and_return('read action URL')
      FinderTestHelper.api.should_receive(:read).with('read action URL').and_yield('json')
      FinderTestHelper.should_receive(:page_from_json).with('json').and_return(:result_of_page_from_json)
    end

    subject { FinderTestHelper.all }

    it { should == :result_of_page_from_json } 
  end

  [ :each, :each_page, :first, :last, :empty?, :to_a ].each do |delegated|
    describe "##{delegated}" do
      it 'delegated to the pages from #all' do
        results = double('results')
        FinderTestHelper.should_receive(:all).and_return(results)
        results.should_receive(delegated).and_return(:object_result)

        FinderTestHelper.send(delegated).should == :object_result
      end
    end
  end
end

describe Sequencescape::Api do
  before(:each) do
    @connection = double('connection')
    described_class.connection_factory = double('connection factory')
    described_class.connection_factory.stub(:create).with(any_args).and_return(@connection)

    @connection.should_receive(:root).and_yield({})
  end

  subject { described_class.new(:url => 'http://localhost:3000/', :cookie => 'testing') }

  describe '#read' do
    it 'is delegated to the connection' do
      expected = double('expected')
      expected.should_receive(:yielded).with(:result)
      @connection.should_receive(:read).with('URL').and_yield(:result)
      subject.read('URL', &expected.method(:yielded))
    end
  end

  describe '#read_uuid' do
    it 'delegates to read with the URL for the UUID' do
      @connection.should_receive(:url_for_uuid).with('UUID').and_return('URL')
      @connection.should_receive(:read).with('URL').and_yield(:result)
      subject.read_uuid('UUID') { |json| json.should == :result }
    end
  end
end

describe Sequencescape::Api::PageOfResults do
  it 'is Enumerable' do
    described_class.included_modules.should include(Enumerable)
  end

  describe '#initialize' do
    it 'errors if there are no actions present' do
      lambda { described_class.new(@api, { 'objects' => [] }) {} }.should raise_error(Sequencescape::Api::Error)
    end

    it 'errors if the actions are empty' do
      lambda { described_class.new(@api, { 'actions' => {}, 'objects' => [] }) {} }.should raise_error(Sequencescape::Api::Error)
    end

    it 'errors if there are no objects present' do
      lambda { described_class.new(@api, { 'actions' => { 'read' => 'a' } }) {} }.should raise_error(Sequencescape::Api::Error)
    end

    it 'ignores the presence of uuids_to_ids' do
      described_class.new(@api, {
        'actions' => { 'read' => 'a' },
        'objects' => [],
        'uuids_to_ids' => false             # Doesn't matter, will just error if used!
      })
    end

    it 'yields the contents of the object json to the block' do
      expected = double('yield helper')
      expected.should_receive(:yielded).with('json1')
      expected.should_receive(:yielded).with('json2')

      described_class.new(@api, {
        'actions' => { 'read' => 'a' },
        'objects' => [ 'json1', 'json2' ],
        'uuids_to_ids' => false             # Doesn't matter, will just error if used!
      }, &expected.method(:yielded))
    end
  end

  context 'once initialised successfully' do
    context 'multiple pages' do
      subject do
        ctor = double('ctor')
        ctor.should_receive(:yielded).with('json1').and_return('a')
        ctor.should_receive(:yielded).with('json2').and_return('b')
        ctor.should_receive(:yielded).with('json3').and_return('c')

        api = double('api')
        api.should_receive(:read).with('page2').and_yield({
          'actions' => {
            'first'    => 'page1',
            'last'     => 'page2',
            'read'     => 'page2',
            'previous' => 'page1'
          },
          'objects' => [
            'json3'
          ]
        })

        described_class.new(api, {
          'actions' => {
            'first' => 'page1',
            'last'  => 'page2',
            'read'  => 'page1',
            'next'  => 'page2'
          },
          'objects' => [
            'json1',
            'json2'
          ]
        }, &ctor.method(:yielded))
      end

      describe '#each_page' do
        it 'yields each page of results' do
          results = []
          subject.each_page { |page| results << page }
          [ [ 'a', 'b' ], [ 'c' ] ].should == results
        end
      end

      describe '#each' do
        it 'behaves like a continuous space' do
          results = []
          subject.each { |r| results << r }
          [ 'a', 'b', 'c' ].should == results
        end
      end

      describe '#to_a' do
        it 'returns all results as an array' do
          subject.to_a.should == [ 'a', 'b', 'c' ]
        end
      end
    end

    describe '#last' do
      subject do
        ctor = double('ctor')
        ctor.should_receive(:yielded).with('json1').and_return('a')
        ctor.should_receive(:yielded).with('json2').and_return('b')
        ctor.should_receive(:yielded).with('json3').and_return('c')

        api = double('api')
        api.should_receive(:read).with('page3').and_yield({
          'actions' => {
            'first'    => 'page1',
            'last'     => 'page3',
            'read'     => 'page3',
            'previous' => 'page1'
          },
          'objects' => [
            'json2',
            'json3'
          ]
        })

        described_class.new(api, {
          'actions' => {
            'first' => 'page1',
            'last'  => 'page3',
            'read'  => 'page1',
            'next'  => 'page2'
          },
          'objects' => [
            'json1'
          ]
        }, &ctor.method(:yielded))
      end

      it 'jumps straight to the last entry on the last page' do
        subject.last.should == 'c'
      end
    end

    describe '#each' do
      context 'resetting' do
        subject do
          ctor = double('ctor')
          ctor.should_receive(:yielded).with('json1').and_return('a')
          ctor.should_receive(:yielded).with('json2').and_return('b')
          ctor.should_receive(:yielded).with('json3').and_return('c')
          ctor.should_receive(:yielded).with('json4').and_return('d')
          ctor.should_receive(:yielded).with('json5').and_return('e')
          ctor.should_receive(:yielded).with('json6').and_return('f')

          api = double('api')
          api.should_receive(:read).with('page2').and_yield({
            'actions' => {
              'first'    => 'page1',
              'last'     => 'page2',
              'read'     => 'page2',
              'previous' => 'page1'
            },
            'objects' => [
              'json3'
            ]
          })
          api.should_receive(:read).with('page1').and_yield({
            'actions' => {
              'first'    => 'page1',
              'last'     => 'page1',
              'read'     => 'page1'
            },
            'objects' => [
              'json4',
              'json5',
              'json6'
            ]
          })

          described_class.new(api, {
            'actions' => {
              'first' => 'page1',
              'last'  => 'page2',
              'read'  => 'page1',
              'next'  => 'page2'
            },
            'objects' => [
              'json1',
              'json2'
            ]
          }, &ctor.method(:yielded))
        end

        it 'resets to the first page on each call' do
          results = []
          subject.each { |r| results << r }
          subject.each { |r| results << r }
          [ 'a', 'b', 'c', 'd', 'e', 'f' ].should == results
        end
      end
    end
  end
end