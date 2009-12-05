require File.dirname(__FILE__)+'/spec_helper'
describe 'Shape in chipmunk' do
  it 'can be created' do
    s = CP::Space.new
  end
  it 'can set its iterations' do
    s = CP::Space.new
    s.iterations = 9
    s.iterations.should == 9
  end
  it 'can set its gravity' do
    s = CP::Space.new
    s.gravity = vec2(4,5)
    s.gravity.x.should == 4
    s.gravity.y.should == 5
  end
end
