require File.dirname(__FILE__)+'/spec_helper'
describe 'CP module' do
  it 'can calculate the moment for a polygon' do
    verts = []
    verts << vec2(1,1)
    verts << vec2(1,2)
    verts << vec2(2,2)
    CP.moment_for_poly(90, verts, vec2(0,0)).should == 420.0
  end

  it 'can give a version' do
    v = CP::VERSION
    # 5.1.0
    v.split(".").size.should == 3
  end
  
  it 'can clamp floats' do
    CP.clamp(2.0, 1.0, 3.0).should == 2.0
    CP.clamp(0.0, 1.0, 3.0).should == 1.0
    CP.clamp(4.0, 1.0, 3.0).should == 3.0
  end
  
  it 'can calculate linear interpolations' do
    CP.flerp(0.0, 1.0, 0.5).should == 0.5
    CP.flerpconst(0.0, 1.0, 0.5).should == 0.5
  end
  
  
end
