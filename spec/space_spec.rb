require File.dirname(__FILE__)+'/spec_helper'
describe 'Space in chipmunk' do
  let(:space) { CP::Space.new }

  check_accessor :space, :gravity, vec2(4,5)
  check_accessor :space, :iterations, 9

  check_accessor :space, :damping, 0.2
  check_accessor :space, :idle_speed, 3
  check_accessor :space, :sleep_time, 1000


  check_accessor :space, :collision_slop, 1.3
  check_accessor :space, :collision_bias, 2.3
  check_accessor :space, :collision_persistence, 5
  check_accessor :space, :contact_graph_enabled, true
  check_accessor :space, :contact_graph_enabled, false

  it 'space missing' do
    pending "# TODO #collision_persistence needs to be uint not float"
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
  
  it 'can have a shape removed from it twice' do
    s     = CP::Space.new
    bod   = CP::Body.new 90, 76
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    lambda { s.add_shape shapy }.should_not raise_error
    lambda { s.remove_shape shapy }.should_not raise_error    
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
  
  it 'can have a static shape removed from it twice' do
    s     = CP::Space.new
    bod   = CP::StaticBody.new
    shapy = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2    
    lambda { s.add_static_shape shapy }.should_not raise_error
    lambda { s.remove_static_shape shapy }.should_not raise_error
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
  
  it 'can have constraints removed twice' do
    space = CP::Space.new
    boda = Body.new 90, 46
    bodb = Body.new 9, 6
    pj = CP::Constraint::PinJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2)
    lambda { space.add_constraint pj }.should_not raise_error
    lambda { space.remove_constraint pj }.should_not raise_error
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

  it 'can remove from the space in old style callbacks' do
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
      space.on_post_step(a) do |spacey, shape|
        spacey.remove_body shape.body
        spacey.remove_shape shape
      end
      1
    end

    space.step 1

    called.should be_true
  end

  it 'can register for post step callbacks' do
    space = CP::Space.new
    calls = []
    space.on_post_step(:any_key_probably_a_shape) do |spacey, key|
      calls << [spacey, key]
    end

    space.step 1

    calls.size.should == 1
    calls[0][0].should == space
    calls[0][1].should == :any_key_probably_a_shape
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
      arbiter.contacts.should == 1
      arr = []
      arbiter.each_contact { |c| arr << c }
      arr.size.should == 1 
      shas = arbiter.shapes
      shas.size.should == 2
      shas[0].should == a
      shas[1].should == b
      bods = arbiter.bodies
      bods.size.should == 2
      bods[0].should == shas[0].body
      bods[1].should == shas[1].body
      points         = arbiter.points
      points.size.should == arbiter.size      
      arbiter.normal(0).class.should == Vec2
      d = arbiter.depth(0).class.should == Float
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

  it 'can have lots of shapes without GC corruption' do
    space = CP::Space.new

    bods = []
    shapes = []
    100.times do |i|   
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
  
  describe 'struct ContactPoint' do
    it 'can be constructed manually' do
      contact = CP::ContactPoint.new(vec2(0,0),vec2(1,0), -10)
      contact.point.should == vec2(0,0)
      contact.normal.should == vec2(1,0)
      contact.dist.should == -10
    end
  end  


end
