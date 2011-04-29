require File.dirname(__FILE__)+'/spec_helper'
describe 'CP module' do
  it 'can give a version' do
    v = CP::VERSION
    # 5.1.0
    v.split(".").size.should == 3
  end
  
  it 'has the ALL_LAYERS constant' do
    v = CP::ALL_LAYERS
    v.should_not == 0
  end
  
  it 'has the NO_GROUP constant' do
    v = CP::NO_GROUP
    v.should == 0
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
  
  it 'can calculate the moment for a polygon' do
    verts = []
    verts << vec2(1,1)
    verts << vec2(1,2)
    verts << vec2(2,2)
    CP.moment_for_poly(90, verts, vec2(0,0)).should == 420.0
  end
  
  it 'can calculate moments for a circle' do
    CP.moment_for_circle(1.0, 1.0, 2.0, vec2(0,0)).should == 2.5
  end
  
  it 'can calculate moments for a segment' do
    mom = CP.moment_for_segment(1.0, vec2(0,0), vec2(1,1))
    mom.should be_within(0.001).of(0.6666)
  end
  
  it 'can calculate moments for a box' do
    mom = CP.moment_for_box(1.0, 3, 2)
    mom.should be_within(0.001).of(1.08333)    
  end
  
  it 'can calculate the area for a polygon' do
    verts = []
    verts << vec2(2, 0)
    verts << vec2(0, 2)
    verts << vec2(0, 0)    
    
    are = CP.area_for_poly(verts)
    are.should be_within(0.001).of(2.0)
  end
  
  it 'can calculate areas for a circle' do
    are = CP.area_for_circle(1.0, 2.0)
    are.should be_within(0.001).of(18.8495)
  end
  
  it 'can calculate areas for a segment' do
    are = CP.area_for_segment(vec2(0,0), vec2(1,1), 1.0)
    are.should be_within(0.001).of(9.111612431925776)
  end
  
  it 'can calculate areas for a box' do
    are = CP.area_for_box(3, 2)
    are.should be_within(0.001).of(6.0)
  end
  
  it 'allows global parameters for Chipmunk to be read and set' do
    CP.bias_coef = 0.2
    CP.bias_coef.should == 0.2
    CP.collision_slop = 0.3
    CP.collision_slop.should == 0.3
    CP.contact_persistence = 4
    CP.contact_persistence.should == 4  
  end

  
end
