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

    space.add_collision_func :foo, :bar do |a,b|
      a.should_not be_nil
      b.should_not be_nil
      @called = true
      1
    end

    space.step 1
    @called.should be_true
  end

  it 'can have lots of shapes no GC corruption' do
    space = CP::Space.new

    bods = []
    shapes = []
    50.times do |i|
      bods[i] = CP::Body.new(90, 76)
      shapes[i] = CP::Shape::Circle.new(bods[i], 40, CP::ZERO_VEC_2)
      shapes[i].collision_type = "bar#{i}".to_sym
      space.add_shape(shapes[i])
      space.add_body(bods[i])
    end

    4000.times do
      space.step 1
    end
  end
end
