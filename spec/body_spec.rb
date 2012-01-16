require File.dirname(__FILE__)+'/spec_helper'

describe 'A new Body' do
  it 'should be creatable' do
    b = CP::Body.new(5, 7)
    b.m.should == 5
    b.i.should == 7
    b.static?.should be_false
    b.sleep?.should be_false
    b.rogue?.should be_true
  end
  
  describe 'StaticBody class' do
    it 'should be creatable using new_static' do
      bs = CP::Body.new_static() 
      bs.m.should == CP::INFINITY
      bs.i.should == CP::INFINITY
      bs.static?.should be_true
      bs.rogue?.should be_true
    end
    
    it 'should be creatable using new' do
      bs = CP::StaticBody.new() 
      bs.m.should == CP::INFINITY
      bs.i.should == CP::INFINITY
      bs.static?.should be_true
      bs.rogue?.should be_true
    end
  end

  it 'can sleep and be activated again' do
    space = CP::Space.new
    b     = CP::Body.new(5, 7)
    b.sleep?.should be_false
    # It's not allowed to make this body sleep yet.
    lambda { b.body_alone}.should raise_error
    b.sleep?.should be_false
    b.activate
    b.sleep?.should be_false
    # Now we add the body to the space, and making it sleep is fine.
    space.add_body(b) 
    lambda { b.sleep_alone}.should_not raise_error
    b.sleep?.should be_true
    b.activate
    b.sleep?.should be_false    
  end
  
  it "'s rogue status is adjusted correctly" do
    b = CP::Body.new(5, 7)
    space = CP::Space.new
    b.rogue?.should be_true
    space.add_body(b)
    b.rogue?.should be_false    
  end
  
  it 'can sleep with a group and be activated again' do
    space = CP::Space.new
    group = CP::Body.new(5, 7)
    b     = CP::Body.new(7, 11)
    space.add_body(group)
    space.add_body(b)
    group.sleep_alone
    lambda { b.sleep_with_group(group)}.should_not raise_error
    b.sleep?.should be_true
    group.activate
    b.sleep?.should be_false    
  end

  it 'can set its mass' do
    b = CP::Body.new(5, 7)
    b.m = 900
    b.m.should == 900
    b.m_inv.should be_within(0.001).of(1.0/900)
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
    b.moment_inv.should be_within(0.001).of(1.0/37)
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

  it 'can update its position' do
    b = CP::Body.new(5, 7)
    b.apply_impulse(vec2(1,0), ZERO_VEC_2)
    b.update_position 25
    b.p.x.should be_within(0.001).of(5)
    b.p.y.should be_within(0.001).of(0)
  end

  it 'can update its velocity over a timestep' do
    b = CP::Body.new(5, 7)
    b.apply_impulse(vec2(1,0), ZERO_VEC_2)
    b.update_velocity vec2(0,0), 0.5, 25
    b.v.x.should be_within(0.001).of(0.1)
    b.v.y.should be_within(0.001).of(0)
  end

# Slew was made opsolete in chipmunk 6.x  
#   it 'can slew to a position' do
#     b = CP::Body.new(5, 7)
#     b.slew(vec2(100, 40), 25)
#     b.v.x.should be_within(0.001).of(4.0)
#     b.v.y.should be_within(0.001).of(1.6)
#   end
  
  it 'can has a kinetic energy' do
    b = CP::Body.new(5, 7)    
    b.kinetic_energy.should == 0.0    
  end
  
  
  
  it 'can have a specific velocity_func callback set' do
    b       = CP::Body.new(5, 7)
    called  = false
    # xxx: doesn't seem to get called, though.
    res = b.velocity_func do |body, gravity, damping, dt|
      body.should_not be_nil
      gravity.should_not be_nil
      damping.should_not be_nil
      dt.should_not be_nil
    end
    res.should_not be_nil
    b.apply_impulse(vec2(1,0), ZERO_VEC_2)
    b.update_velocity vec2(0,0), 0.5, 25
    b.v.x.should be_within(0.001).of(0.1)
    b.v.y.should be_within(0.001).of(0)
    # Restore velocity callback.
    res = b.velocity_func
    res.should be_nil
  end
  
  it 'can have a specific position_func callback set' do
    b       = CP::Body.new(5, 7)
    called  = false
    # xxx: doesn't seem to get called, though.
    res = b.position_func do |body,  dt|
      body.should_not be_nil
      dt.should_not be_nil
    end
    res.should_not be_nil
    b.apply_impulse(vec2(1,0), ZERO_VEC_2)
    b.update_velocity vec2(0,0), 0.5, 25
    b.v.x.should be_within(0.001).of(0.1)
    b.v.y.should be_within(0.001).of(0)
    # Restore position callback.
    res = b.position_func
    res.should be_nil
  end
  
  it 'can have an arbitrary object connected to it' do
    b  = CP::Body.new(5, 7)
    o  = "Hello"
    b.object = o
    b.object.should == o
  end
  
  

end
