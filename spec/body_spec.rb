describe 'A new Body' do
  it 'should be creatable' do
    b = CP::Body.new(5, 7)
    b.m.should == 5
    b.i.should == 7
  end

  it 'can set its mass' do
    b = CP::Body.new(5, 7)
    b.m = 900
    b.m.should == 900
  end

  it 'can set its pos' do
    b = CP::Body.new(5, 7)
    b.p.x.should == 0
    b.p.y.should == 0

    b.pos = vec2(4,6)
#    b.pos.x.should == 4
#    b.pos.y.should == 6
  end

  it 'can set its moment'
  it 'can set its vel'
  it 'can set its force'
  it 'can set its angle'
  it 'can set its angle_vel'
  it 'can set its torque'
  it 'can get its rot'
  it 'can get local2world'
  it 'can get world2local'
  it 'can reset its forces'
  it 'can apply force'
  it 'can apply impulse'
  it 'can update its velocity over a timestep'

  it 'should be able to update its position' do
    b = CP::Body.new(5, 7)
    b.update_position 25
  end
end
