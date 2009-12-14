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

  it 'can have a shape added to it' do
    s = CP::Space.new
    bod = CP::Body.new 90, 76
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    p shapy.struct.hash_value
    p shapy.struct.data.read_int
    s.add_shape shapy

  end

  it 'can have a shapes collide' do
    space = CP::Space.new
    bod = CP::Body.new 90, 76
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    shapy.collision_type = :foo

    bod_one = CP::Body.new 90, 76
    shapy_one = CP::Shape::Circle.new bod_one, 40, CP::ZERO_VEC_2
    shapy_one.collision_type = :bar
    space.add_shape shapy
    space.add_shape shapy_one

    @shapes = []
    @@procs ||= []
    beg = Proc.new do |arb_ptr,space_ptr,data_ptr|
#      puts "HERE"
      arb = ArbiterStruct.new(arb_ptr)
      sh = ShapeStruct.new(arb.b)
      b_obj_id = sh.data.get_ulong 0
      rb_b = ObjectSpace._id2ref b_obj_id
      @shapes << rb_b
#      p rb_b
      # return 1 or 0 (true to continue)
      1
    end
    pre = nil
    post = nil
    sep = nil
    data = nil

    @@procs << beg

    CP.cpSpaceAddCollisionHandler(space.struct.pointer, :foo.object_id, :bar.object_id, beg,pre,post,sep,data)

    space.step 1

    p @shapes

  end
end
