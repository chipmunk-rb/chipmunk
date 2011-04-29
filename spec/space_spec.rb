require File.dirname(__FILE__)+'/spec_helper'
describe 'Space in chipmunk' do
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
    s     = CP::Space.new
    bod   = CP::Body.new 90, 76
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    lambda { s.add_shape shapy }.should_not raise_error
  end
  
  it 'can have a shape removed from to it' do
    s     = CP::Space.new
    bod   = CP::Body.new 90, 76
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    lambda { s.add_shape shapy }.should_not raise_error
    lambda { s.remove_shape shapy }.should_not raise_error
  end
  
  
  it 'can have a static shape added to it' do
    s     = CP::Space.new
    bod   = CP::StaticBody.new
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2    
    lambda { s.add_static_shape shapy }.should_not raise_error
  end
  
  it 'can have a static shape removed from it' do
    s     = CP::Space.new
    bod   = CP::StaticBody.new
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2    
    lambda { s.add_static_shape shapy }.should_not raise_error
    lambda { s.remove_static_shape shapy }.should_not raise_error
  end
  
  it 'can have constraints added' do
    space = CP::Space.new
    boda = Body.new 90, 46
    bodb = Body.new 9, 6
    pj = CP::Constraint::PinJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2)
    lambda { space.add_constraint pj }.should_not raise_error
  end

  it 'can have constraints removed' do
    space = CP::Space.new
    boda = Body.new 90, 46
    bodb = Body.new 9, 6
    pj = CP::Constraint::PinJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2)
    lambda { space.add_constraint pj }.should_not raise_error
    lambda { space.remove_constraint pj }.should_not raise_error
  end
  
  it 'can have bodies added' do
    space = CP::Space.new
    body  = Body.new 90, 46
    lambda { space.add_body(body) }.should_not raise_error
  end

  it 'can have bodies removed' do
    space = CP::Space.new
    body  = Body.new 90, 46
    lambda { space.add_body(body) }.should_not raise_error
    lambda { space.remove_body(body) }.should_not raise_error
  end
  
  it 'can activate touching shapes' do
    space = CP::Space.new
    boda  = Body.new 90, 46
    bodb  = Body.new 9, 6
    shaa  = CP::Shape::Circle.new boda, 40, CP::ZERO_VEC_2
    shab  = CP::Shape::Circle.new bodb, 20, CP::ZERO_VEC_2
    space.add_shape(shaa)
    space.add_shape(shab)
    lambda { space.activate_touching(shaa) }.should_not raise_error  
  end
   
  it 'can resize its spacial hashes' do
    space = CP::Space.new
    lambda { space.resize_static_hash(10.0, 2000) }.should_not raise_error
    lambda { space.resize_active_hash(10.0, 2000) }.should_not raise_error
    lambda { space.rehash_static() }.should_not raise_error
  end 

  it 'can be stepped' do
    space = CP::Space.new  
    lambda { space.step(0.5) }.should_not raise_error
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
    space.add_collision_func :foo, :bar do |a, b, arb|
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
    attr_reader :pre_solve_called
    attr_reader :post_solve_called
    
    # Arity 3:
    def begin(a, b, arbiter)
      # NOTE: Arbiter can be read here, but never ever stored anywhere.
      # Arbiters are managed internally by chipmunk and are destroyed upon 
      # the end of the callback.
      @begin_called = [a,b]
      arbiter.a.should == a
      arbiter.b.should == b
      arbiter.e.should == 0.0
      arbiter.e.should == 0.0
#       p arbiter.point(0) 
#       p arbiter.normal(0)
#       p arbiter.impulse(0)
      arbiter.first_contact?.should == true
      arbiter.num_contacts.should == 1
      arr = []
      arbiter.each_contact { |c| arr << c }
      arr.size.should == 1 
      arbiter.shapes.size.should == 2 
      true
    end
    
    # Arity 2: 
    def pre_solve(a, b)
      @pre_solve_called = [a,b]
    end
    
    # Arity 1:
    def post_solve(arbiter)
      @post_solve_called = [arbiter.a, arbiter.b]
      arbiter.a.should_not.nil?
      arbiter.b.should_not.nil?
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
    # Check if handler was called correctly.
    ch.begin_called[0].should == shapy
    ch.begin_called[1].should == shapy_one
    ch.pre_solve_called[0].should == shapy
    ch.pre_solve_called[1].should == shapy_one
    ch.post_solve_called[0].should == shapy
    ch.post_solve_called[1].should == shapy_one
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


  it 'can do a first point query finds the shape' do
    space = CP::Space.new
    bod = CP::Body.new 90, 76
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    shapy.collision_type = :foo

    space.add_shape shapy

    obj = space.point_query_first(vec2(20,20),~0,0)
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

  it 'can do a point query finds the shape' do
    space = CP::Space.new
    bod = CP::Body.new 90, 76
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    shapy.collision_type = :foo

    space.add_shape shapy

    obj = space.shape_point_query(vec2(20,20))
    obj.should == shapy

  end

  it 'can do a bb query' do
    space = CP::Space.new
    bod = CP::Body.new 90, 76
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    shapy.collision_type = :foo

    space.add_shape shapy
    
    # Doing it using the hash is not needed anymore. 
    # hash = space.active_shapes_hash
    # shapes = hash.query_by_bb BB.new(0,0,5,5)
    bb      = BB.new(0,0,5,5)
    shapes  = []
    space.bb_query(bb) { |shape| shapes << shape }
    
    shapes.size.should == 1
    shapes.first.should == shapy
  end
  
  it 'can have an arbitrary object connected to it' do
    b  = CP::Space.new
    o  = "Hello"
    b.object = o
    b.object.should == o
  end
  
  it 'can set and get its idle speed' do
    b  = CP::Space.new  
    b.idle_speed = 1.0
    b.idle_speed.should == 1.0
  end
  
  it 'can set and get its sleep time' do
    b  = CP::Space.new  
    b.sleep_time = 1000.0
    b.sleep_time.should == 1000.0
  end
  
  


end
