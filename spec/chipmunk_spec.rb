require File.dirname(__FILE__)+'/spec_helper'
describe 'CP module' do
  it 'CP should calc moment for poly' do
    verts = []
    verts << vec2(1,1)
    verts << vec2(1,2)
    verts << vec2(2,2)
    # will fail for precision
    CP.moment_for_poly(90, verts, vec2(0,0)).should == 420.0
  end
end
