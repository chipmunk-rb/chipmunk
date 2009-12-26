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
    s.add_shape shapy

  end

  it 'can have old style callbacks' do
    space = CP::Space.new
    bod = CP::Body.new 90, 76
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    shapy.collision_type = :foo

    bod_one = CP::Body.new 90, 76
    shapy_one = CP::Shape::Circle.new bod_one, 40, CP::ZERO_VEC_2
    shapy_one.collision_type = :bar
    space.add_shape shapy
    space.add_shape shapy_one

    called = false
    space.add_collision_func :foo, :bar do |a,b|
      a.should_not be_nil
      b.should_not be_nil
      called = true
      1
    end

    space.step 1
    called.should be_true
  end

  class CollisionHandler
    attr_reader :begin_called
    def begin(a,b)
      @begin_called = [a,b]
    end
  end

  it 'can have new style callbacks' do
    ch = CollisionHandler.new

    space = CP::Space.new
    bod = CP::Body.new 90, 76
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    shapy.collision_type = :foo

    bod_one = CP::Body.new 90, 76
    shapy_one = CP::Shape::Circle.new bod_one, 40, CP::ZERO_VEC_2
    shapy_one.collision_type = :bar
    space.add_shape shapy
    space.add_shape shapy_one

    space.add_collision_handler :foo, :bar, ch

    space.step 1
    
    ch.begin_called[0].should == shapy
    ch.begin_called[1].should == shapy_one
  end

  it 'can have lots of shapes no GC corruption' do
    space = CP::Space.new

    bods = []
    shapes = []
    5.times do |i|
      bods[i] = CP::Body.new(90, 76)
      shapes[i] = CP::Shape::Circle.new(bods[i], 40, CP::ZERO_VEC_2)
      shapes[i].collision_type = "bar#{i}".to_sym
      space.add_shape(shapes[i])
      space.add_body(bods[i])
    end

    GC.start

    space.step 1
  end

  it 'can have constraints added' do
    space = CP::Space.new

    boda = Body.new 90, 46
    bodb = Body.new 9, 6
    pj = CP::PinJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2)

    space.add_constraint pj
  end

  it 'can do a first point query finds the shape' do
    space = CP::Space.new
    bod = CP::Body.new 90, 76
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    shapy.collision_type = :foo

    space.add_shape shapy

    all_ones = 2**32-1
    obj = space.point_query_first(vec2(20,20),all_ones,0)
    obj.should == shapy

  end

  it 'can do a first point query does not find anything' do
    space = CP::Space.new
    bod = CP::Body.new 90, 76
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    shapy.collision_type = :foo

    space.add_shape shapy

    all_ones = 2**32-1
    obj = space.point_query_first(vec2(20,50),all_ones,0)
    obj.should be_nil

  end

  it 'can do a point query' do
    space = CP::Space.new
    bod = CP::Body.new 90, 76
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    shapy.collision_type = :foo

    space.add_shape shapy
    
    all_ones = 2**32-1
		
    shapes = []
    space.point_query vec2(20,20), all_ones,0 do |shape|
      shapes << shape
    end
    
    shapes.size.should == 1
    shapes.first.should == shapy
  end

  it 'can do a bb query' do
    space = CP::Space.new
    bod = CP::Body.new 90, 76
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    shapy.collision_type = :foo

    space.add_shape shapy
    
    hash = space.active_shapes_hash
    shapes = hash.query_by_bb BB.new(0,0,5,5)
    
    shapes.size.should == 1
    shapes.first.should == shapy
  end

end
