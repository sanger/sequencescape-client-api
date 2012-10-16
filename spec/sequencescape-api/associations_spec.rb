require 'spec_helper'

describe 'Various associations' do
  is_working_as_an_unauthorised_client

  context 'has_many' do
    context 'with size included in the JSON' do
      stub_request_from('retrieve-model') { response('model-a-instance') }

      subject { api.model_a.find('UUID').model_bs }

      its(:size) { should == 3 }

      context do
        stub_request_and_response('s2-results-page-1')
        stub_request_and_response('s2-results-page-2')
        stub_request_and_response('s2-results-page-3')

        it_behaves_like 'a paged result'
      end

      context '#first' do
        stub_request_and_response('s2-results-page-1')

        it 'only loads the page needed' do
          subject.first.should_not be_nil
        end
      end

      context '#last' do
        stub_request_and_response('s2-results-page-1')
        stub_request_from('retrieve-s2-results-page-last') { response('s2-results-page-3') }

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

    context ':disposition => :receptacle_inline' do
      stub_request_from('retrieve-model') { response('model-d-instance') }

      subject { api.model_d.find('UUID').model_es }

      its(:size) { should == 3 }

      it 'should behave like a receptacle' do
        subject.first.location.should eq("A1")
        subject.first.aliquots.size.should == 2
        subject.should respond_to(:each)
      end
    end

    context ':disposition => :receptacle_inline via page' do
          stub_request_from('retrieve-model-page') { response('model-d-page') }
          #stub_request_from('retrieve-model') { response('model-d-instance') }

          subject { api.model_d.first.model_es }

          its(:size) { should == 3 }

          it 'should behave like a receptacle' do
            subject.first.location.should eq("A1")
            subject.first.aliquots.size.should == 2
            subject.should respond_to(:each)
          end
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

      it 'has grouped data' do
        subject.group.data.should == 'early group data from JSON'
      end

      context do
        stub_request_and_response('belongs-to-association')
        its(:data) { should == 'data from JSON' }
      end
    end
  end
end
