require File.dirname(__FILE__)+'/spec_helper'
describe 'CP module' do
  it 'CP should calc moment for poly' do
    verts = []
    verts << vec2(1,1)
    verts << vec2(1,2)
    verts << vec2(2,2)
    moment_for_poly(90, verts, vec2(0,0)).should == 420.0
  end

  it 'can give a version' do
    v = CP::VERSION
    # 5.0.0
    v.split(".").size.should == 3
  end
end
