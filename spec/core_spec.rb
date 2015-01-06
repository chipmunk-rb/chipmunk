require File.dirname(__FILE__)+'/spec_helper'
describe 'CP module' do
  it 'can give a version' do
    v = CP::VERSION
    # 6.1.3.2
    v.split(".").should == %w(6 1 3 2)
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
    verts << vec2(0, 0)    
    verts << vec2(0, 2)
    verts << vec2(2, 0)

    
    are = CP.area_for_poly(verts)
    are.should be_within(0.001).of(2.0)
  end
  
  it 'can calculate areas for a circle' do
    are = CP.area_for_circle(1.0, 2.0)
    are.should be_within(0.001).of(3*Math::PI)
  end
  
  it 'can calculate areas for a segment' do
    are = CP.area_for_segment(vec2(0,0), vec2(0,1), 1.0)
    are.should be_within(0.001).of(Math::PI+2)
  end
  
  it 'can calculate areas for a box' do
    are = CP.area_for_box(3, 2)
    are.should be_within(0.001).of(6.0)
  end
  
  it 'can calculate the centroid for a polygon' do
    verts = []
    verts << vec2(1,1)
    verts << vec2(1,2)
    verts << vec2(2,2)
    res = CP.centroid_for_poly(verts)
    res.x.should be_within(0.001).of(1.333)
    res.y.should be_within(0.001).of(1.666)
  end
    
  it 'can recenter a polygon' do
    verts = []
    verts << vec2(1,1)
    verts << vec2(1,2)
    verts << vec2(2,2)
    res = CP.recenter_poly(verts)
    res.size.should == 3
  end
  
  
end
