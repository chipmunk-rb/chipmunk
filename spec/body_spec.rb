require File.dirname(__FILE__)+'/spec_helper'

describe 'A new Body' do
  it 'should be creatable' do
    b = CP::Body.new(5, 7)
    b.m.should == 5
    b.i.should == 7
    b.static?.should be_false
    b.sleep?.should be_false
  end
  
  describe 'StaticBody class' do
    it 'should be creatable' do
      b = CP::StaticBody.new()
      # fails somehow: b.static?.should == true
    end
  end


  it 'can set its mass' do
    b = CP::Body.new(5, 7)
    b.m = 900
    b.m.should == 900
    b.m_inv.should be_close(1.0/900, 0.001)
  end

  it 'can set its pos' do
    b = CP::Body.new(5, 7)
    b.p.x.should == 0
    b.p.y.should == 0

    b.pos = vec2(4,6)
    b.pos.x.should == 4
    b.pos.y.should == 6
  end

  it 'can set its vel' do
    b = CP::Body.new(5, 7)
    b.p.x.should == 0
    b.p.y.should == 0

    b.v = vec2(4,6)
    b.v.x.should == 4
    b.v.y.should == 6
  end

  it 'can set its moment' do
    b = CP::Body.new(5, 7)
    b.moment = 37
    b.moment.should == 37
    b.moment_inv.should be_close(1.0/37, 0.001)
  end

  it 'can set its force' do
    b = CP::Body.new(5, 7)
    b.f.x.should == 0
    b.f.y.should == 0

    b.f = vec2(4,6)
    b.f.x.should == 4
    b.f.y.should == 6
  end

  it 'can set its angle' do
    b = CP::Body.new(5, 7)
    b.a = 37
    b.a.should == 37
  end

  it 'can set its angle_vel' do
    b = CP::Body.new(5, 7)
    b.w = 37
    b.w.should == 37
  end

  it 'can set its torque' do
    b = CP::Body.new(5, 7)
    b.t = 37
    b.t.should == 37
  end

  it 'can get its rot' do
    b = CP::Body.new(5, 7)
    b.rot.x.should == 1
    b.rot.y.should == 0
  end

  it 'can set its v_limit' do
    b = CP::Body.new(5, 7)
    b.v_limit = 37
    b.v_limit.should == 37
  end

  it 'can get its v_limit' do
    b = CP::Body.new(5, 7)
    b.v_limit.should === CP::INFINITY
  end

  it 'can set its w_limit' do
    b = CP::Body.new(5, 7)
    b.w_limit = 37
    b.w_limit.should == 37
  end

  it 'can get its w_limit' do
    b = CP::Body.new(5, 7)
    b.w_limit.should === CP::INFINITY
  end

  it 'can get local2world' do
    b = CP::Body.new(5, 7)
    b.pos = vec2(4,6)
    v = b.local2world(vec2(0,0))
    v.x.should == 4
    v.y.should == 6
  end

  it 'can get world2local' do
    b = CP::Body.new(5, 7)
    b.pos = vec2(4,6)
    v = b.world2local(vec2(4,6))
    v.x.should == 0
    v.y.should == 0
  end

  it 'can reset its forces' do
    b = CP::Body.new(5, 7)
    b.f = vec2(4,6)
    b.reset_forces
    b.f.x.should == 0
    b.f.y.should == 0
  end

  it 'can apply force' do
    b = CP::Body.new(5, 7)
    b.apply_force(vec2(1,0), ZERO_VEC_2)
    b.f.x.should == 1
    b.f.y.should == 0
  end

  it 'can apply impulse' do
    b = CP::Body.new(5, 7)
    b.apply_impulse(vec2(1,0), ZERO_VEC_2)
    # shouldn't mess with force
    b.f.x.should == 0
    b.f.y.should == 0

    b.v.x.should == 0.2
    b.v.y.should == 0
  end

  it 'should be able to update its position' do
    b = CP::Body.new(5, 7)
    b.apply_impulse(vec2(1,0), ZERO_VEC_2)
    b.update_position 25
    b.p.x.should be_close(5,0.001)
    b.p.y.should be_close(0,0.001)
  end

  it 'can update its velocity over a timestep' do
    b = CP::Body.new(5, 7)
    b.apply_impulse(vec2(1,0), ZERO_VEC_2)
    b.update_velocity vec2(0,0), 0.5, 25
    b.v.x.should be_close(0.1,0.001)
    b.v.y.should be_close(0,0.001)
  end

end
