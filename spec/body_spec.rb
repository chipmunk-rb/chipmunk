describe 'A new Body' do
  it 'should be creatable' do
    b = CP::Body.new(5, 7)
    b.m.should == 5
    b.i.should == 7
  end
end
