require 'spec_helper'

describe Sequencescape::Api::FinderMethods::FindByUuidHandler do
  before(:each) do
    @owner = double('owner')
  end

  subject { described_class.new(@owner) }

  describe '#success' do
    it 'creates through the owner' do
      @owner.should_receive(:new).with('json', true).and_return(:result)
      subject.success('json').should == :result
    end
  end
end

describe Sequencescape::Api::FinderMethods::AllHandler do
  before(:each) do
    @owner = double('owner')
  end

  subject { described_class.new(@owner) }

  describe '#success' do
    it 'creates a page of results'
  end
end

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
    it 'delegates handling to the appropriate handler' do
      FinderTestHelper.api.should_receive(:read_uuid).with('UUID', instance_of(described_class::FindByUuidHandler))
      FinderTestHelper.find('UUID')
    end
  end

  describe '#all' do
    it 'delegates handling to the appropriate handler' do
      FinderTestHelper.stub_chain('actions.read').and_return('read action URL')
      FinderTestHelper.api.should_receive(:read).with('read action URL', instance_of(described_class::AllHandler))
      FinderTestHelper.all
    end
  end

  [ 
    # Enumerable methods
    :each, :first, :last, :empty?, :size, :to_a,

    # Paging methods
    :each_page, :first_page, :last_page
  ].each do |delegated|
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
    def @connection.root(handler)
      pseudo_root(&handler.method(:success))
    end
    @connection.should_receive(:pseudo_root).and_yield({})

    described_class.connection_factory = double('connection factory')
    described_class.connection_factory.stub(:create).with(any_args).and_return(@connection)
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
      @connection.should_receive(:read).with('URL', :handler)
      subject.read_uuid('UUID', :handler)
    end
  end
end

describe Sequencescape::Api::PageOfResults do
  it 'is Enumerable' do
    described_class.included_modules.should include(Enumerable)
  end

  before(:each) do
    @api = double('api')
    def @api.read(url, handler)
      pseudo_read(url, &handler.method(:success))
    end
  end

  shared_examples_for 'initialization behaviour' do |options_to_check|
    def should_error_for_bad_json(json)
      lambda do
        described_class.new(@api, json) { }
      end.should raise_error(Sequencescape::Api::Error)
    end

    good_json = { 'actions' => { 'read' => 'a' }, 'objects' => [], 'size' => 100 }
    (good_json.keys - options_to_check).map(&good_json.method(:delete))
    options_to_check.each do |attribute|
      json = good_json.dup.tap { |j| j.delete(attribute) }
      it "errors when #{attribute.inspect} is missing" do
        should_error_for_bad_json(json)
      end
    end

    it 'errors when the actions are empty' do
      should_error_for_bad_json(good_json.merge('actions' => {}))
    end

    it 'errors when the size is blank' do
      should_error_for_bad_json(good_json.merge('size' => ''))
    end if options_to_check.include?('size')

    it 'ignores the presence of uuids_to_ids' do
      described_class.new(@api, good_json.merge('uuids_to_ids' => false))
    end

    it 'yields the contents of the object json to the block' do
      expected = double('yield helper')
      expected.should_receive(:yielded).with('json1')
      expected.should_receive(:yielded).with('json2')

      described_class.new(
        @api,
        good_json.merge('objects' => [ 'json1', 'json2' ]),
        &expected.method(:yielded)
      )
    end
  end

  def construct_page(json)
    ctor = double('ctor')
    ctor.stub(:yielded).with(any_args).and_return('object')

    page = described_class.new(@api, {
      'actions' => {
        'read'     => 'first',
        'first'    => 'first',
        'last'     => 'last',
        'next'     => 'next',
        'previous' => 'previous'
      }
    }.merge(json), &ctor.method(:yielded))
  end

  context 'API revision 1' do
    before(:each) do
      @api.stub_chain('capabilities.size_in_pages?').and_return(false)
    end

    describe '#initialize' do
      it_should_behave_like('initialization behaviour', [ 'actions', 'objects' ])
    end

    describe '#empty?' do
      it 'is not empty with objects' do
        construct_page('objects' => [ 'json1', 'json2' ]).should_not be_empty
      end

      it 'is empty with no objects' do
        construct_page('objects' => []).should be_empty
      end
    end
  end

  context 'API revision 2' do
    before(:each) do
      @api.stub_chain('capabilities.size_in_pages?').and_return(true)
    end

    describe '#initialize' do
      it_should_behave_like('initialization behaviour', [ 'actions', 'objects', 'size' ])
    end

    describe '#empty?' do
      it 'is not empty with a size > 0' do
        construct_page('size' => 2, 'objects' => []).should_not be_empty
      end

      it 'is empty with a size == 0' do
        construct_page('size' => 0, 'objects' => [ 'json1', 'json2' ]).should be_empty
      end
    end

    shared_examples_for 'single paging method' do |page|
      before(:each) do
        # The JSON should be parsed for each element
        @ctor = double('ctor')
        @ctor.should_receive(:yielded).with('json1').and_return('a')
        @ctor.should_receive(:yielded).with('json2').and_return('b')
        @ctor.should_receive(:yielded).with('json3').and_return('c')
        @ctor.should_receive(:yielded).with('json4').and_return('d')

        # There should be a read for the page
        @api.should_receive(:pseudo_read).with(page).and_yield({
          'actions' => {
            'first'    => 'first after read',
            'last'     => 'last after read',
            'next'     => 'next after read',
            'previous' => 'previous after read'
          },
          'objects' => [ 'json3', 'json4' ],
          'size' => 2
        })
      end

      subject do
        described_class.new(@api, {
          'actions' => {
            'first'    => 'first',
            'last'     => 'last',
            'next'     => 'next',
            'previous' => 'previous'
          },
          'objects' => [ 'json1', 'json2' ],
          'size' => 2
        }, &@ctor.method(:yielded))
      end

      it 'yields the objects for the page' do
        expected = double('expectation')
        expected.should_receive(:yielded).with([ 'c', 'd' ])

        subject.send(:"#{page}_page", &expected.method(:yielded))
      end
    end

    describe '#first_page' do
      it_should_behave_like('single paging method', 'first')
    end

    describe '#last_page' do
      it_should_behave_like('single paging method', 'last')
    end

    context 'multiple pages' do
      subject do
        ctor = double('ctor')
        ctor.should_receive(:yielded).with('json1').and_return('a')
        ctor.should_receive(:yielded).with('json2').and_return('b')
        ctor.should_receive(:yielded).with('json3').and_return('c')

        @api.should_receive(:pseudo_read).with('page2').and_yield({
          'actions' => {
            'first'    => 'page1',
            'last'     => 'page2',
            'read'     => 'page2',
            'previous' => 'page1'
          },
          'objects' => [
            'json3'
          ],
          'size' => 100
        })

        described_class.new(@api, {
          'actions' => {
            'first' => 'page1',
            'last'  => 'page2',
            'read'  => 'page1',
            'next'  => 'page2'
          },
          'objects' => [
            'json1',
            'json2'
          ],
          'size' => 100
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

        @api.should_receive(:pseudo_read).with('page3').and_yield({
          'actions' => {
            'first'    => 'page1',
            'last'     => 'page3',
            'read'     => 'page3',
            'previous' => 'page1'
          },
          'objects' => [
            'json2',
            'json3'
          ],
          'size' => 100
        })

        described_class.new(@api, {
          'actions' => {
            'first' => 'page1',
            'last'  => 'page3',
            'read'  => 'page1',
            'next'  => 'page2'
          },
          'objects' => [
            'json1'
          ],
          'size' => 100
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

          @api.should_receive(:pseudo_read).with('page2').and_yield({
            'actions' => {
              'first'    => 'page1',
              'last'     => 'page2',
              'read'     => 'page2',
              'previous' => 'page1'
            },
            'objects' => [
              'json3'
            ],
            'size' => 100
          })
          @api.should_receive(:pseudo_read).with('page1').and_yield({
            'actions' => {
              'first'    => 'page1',
              'last'     => 'page1',
              'read'     => 'page1'
            },
            'objects' => [
              'json4',
              'json5',
              'json6'
            ],
            'size' => 100
          })

          described_class.new(@api, {
            'actions' => {
              'first' => 'page1',
              'last'  => 'page2',
              'read'  => 'page1',
              'next'  => 'page2'
            },
            'objects' => [
              'json1',
              'json2'
            ],
            'size' => 100
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
