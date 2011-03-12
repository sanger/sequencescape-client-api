require 'spec_helper'

describe 'Various associations' do
  is_working_as_an_unauthorised_client

  context 'has_many' do
    shared_examples_for 'a paged result' do
      it 'physically contains 3 items' do
        subject.map(&:inspect).size.should == 3
      end

      it 'can be walked in pages' do
        check = double('check that page gets called at least once')
        check.should_receive(:called).at_least(1).at_most(3)

        subject.each_page(&check.method(:called))
      end
    end

    context 'with size included in the JSON' do
      stub_request_from('retrieve-model') { response('model-a-instance') }

      subject { api.model_a.find('UUID').model_bs }

      its(:size) { should == 3 }

      context do
        stub_request_and_response('results-page-1')
        stub_request_and_response('results-page-2')
        stub_request_and_response('results-page-3')

        it_behaves_like 'a paged result'
      end

      context '#first' do
        stub_request_and_response('results-page-1')

        it 'only loads the page needed' do
          subject.first.should_not be_nil
        end
      end

      context '#last' do
        stub_request_and_response('results-page-1')
        stub_request_and_response('results-page-3')

        it 'only loads the pages needed' do
          subject.last.should_not be_nil
        end
      end
    end

    context ':disposition => :inline' do
      stub_request_from('retrieve-model') { response('model-c-instance') }

      subject { api.model_c.find('UUID').model_bs }

      its(:size) { should == 3 }

      it_behaves_like 'a paged result'
    end
  end

  context 'belongs_to' do
    stub_request_from('retrieve-model') { response('model-b-instance') }

    let(:resource) { api.model_b.find('UUID') }

    [ :model_a, :model_by_simple_name, :model_by_full_name ].each do |association_name|
      context "expressed as #{association_name.inspect}" do
        stub_request_and_response('belongs-to-association')

        subject { resource.send(association_name) }

        its(:name) { should == 'name from JSON' }

        it 'will not load the association twice' do
          subject.name.should == 'name from JSON'
          subject.name.should == 'name from JSON'
        end
      end
    end

    context 'when some data is included in the association' do
      subject { resource.model_with_early_data }

      its(:name) { should == 'early data from JSON' }

      context do
        stub_request_and_response('belongs-to-association')
        its(:data) { should == 'data from JSON' }
      end
    end
  end
end
