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
