require File.dirname(__FILE__)+'/spec_helper'
describe 'Vect in chipmunk' do
  describe 'global modifications' do
    it 'should create vec2 global func' do
      v = vec2(4,3)
      v.class.should == CP::Vec2
      v.x.should == 4
      v.y.should == 3
    end
    it 'should create ZERO_VEC_2 to use' do
      v = CP::ZERO_VEC_2
      v.x.should == 0
      v.y.should == 0
    end

    it 'should freeze ZERO_VEC_2' do
      v = CP::ZERO_VEC_2
      v.frozen?.should be_true
      lambda {v.x = 5}.should raise_error
      v.x.should == 0
    end
  end
  describe 'Vec2 class' do
    it 'can be created by x,y' do
      v = CP::Vec2.new(1,3)
      v.x.should == 1
      v.y.should == 3
    end

    it 'can add and not modify orig' do
      v1 = CP::Vec2.new(1,3)
      v2 = v1 + CP::Vec2.new(4,9)
      v1.x.should == 1
      v1.y.should == 3

      v2.x.should == 5
      v2.y.should == 12
    end

    it 'can subtract and not modify orig' do
      v1 = CP::Vec2.new(1,3)
      v2 = v1 - CP::Vec2.new(4,9)
      v1.x.should == 1
      v1.y.should == 3

      v2.x.should == -3
      v2.y.should == -6
    end

    it 'can multiply and not modify orig' do
      v1 = CP::Vec2.new(1,3)
      v2 = v1 * 3
      v1.x.should == 1
      v1.y.should == 3

      v2.x.should == 3
      v2.y.should == 9
    end

    it 'can divide and not modify orig' do
      v1 = CP::Vec2.new(9,3)
      v2 = v1 / 3
      v1.x.should == 9
      v1.y.should == 3

      v2.x.should == 3
      v2.y.should == 1
    end

    it 'can set and get x,y' do
      v = CP::Vec2.new(4,5)
      v.x = 7
      v.y = 2
      v.x.should == 7
      v.y.should == 2
    end

    it 'can report itself into a string' do
      v = CP::Vec2.new(4,5)
      v.to_s.should == "( 4.000,  5.000)"
    end

    it 'can create a Vec2 from an angle (0)' do
      v = CP::Vec2.for_angle(0)    
      v.x.should == 1
      v.y.should == 0
    end

    it 'can create a Vec2 from an angle (PI)' do
      v = CP::Vec2.for_angle(Math::PI)    
      v.x.should be_close(-1,0.001)
      v.y.should be_close(0,0.001)
    end

    it 'can give the angle of the Vec2' do
      v = CP::Vec2.new(-1,0)
      v.to_angle.should be_close(Math::PI,0.001)
    end

    it 'can return an array of itself' do
      v = CP::Vec2.new(-1,0)
      v.to_a.should == [-1,0]
    end

    it 'can return the negated version of itself' do
      v = -CP::Vec2.new(-1,-4)
      v.x.should == 1
      v.y.should == 4
    end

    it 'can return the normalized version of itself' do
      v = CP::Vec2.new(10,20).normalize
      v.x.should be_close(0.447,0.001)
      v.y.should be_close(0.894,0.001)
    end

    it 'can normalize_safe' do
      v = CP::Vec2.new(10,20).normalize_safe
      v.x.should be_close(0.447,0.001)
      v.y.should be_close(0.894,0.001)
    end

    it 'can normalize_safe on zero vec' do
      v = CP::Vec2.new(0,0).normalize_safe
      v.x.should be_close(0,0.001)
      v.y.should be_close(0,0.001)
    end

    it 'can be normalized! (with a bang)' do
      v = CP::Vec2.new(10,20)
      v2 = v.normalize!
      v.x.should be_close(0.447,0.001)
      v.y.should be_close(0.894,0.001)

      v2.x.should be_close(0.447,0.001)
      v2.y.should be_close(0.894,0.001)
    end

    it 'can get its own length' do 
      v = CP::Vec2.new(10,20)
      v.length.should be_close(22.361, 0.001)
    end

    it 'can get its own lengthsq' do 
      v = CP::Vec2.new(10,20)
      v.lengthsq.should be_close(500, 0.001)
    end

    it 'can dot' do
      v = CP::Vec2.new(2,3)
      other_v = CP::Vec2.new(4,5)

      v.dot(other_v).should be_close(23.0, 0.001)
    end

    it 'can cross' do
      v = CP::Vec2.new(2,3)
      other_v = CP::Vec2.new(4,5)

      v.cross(other_v).should be_close(-2.0, 0.001)
    end

    it 'can get dist from other vec2' do
      v = CP::Vec2.new(1,1)
      other_v = CP::Vec2.new(2,2)

      v.dist(other_v).should be_close(Math.sqrt(2), 0.001)
    end

    it 'can get dist squared from other vec2' do
      v = CP::Vec2.new(1,1)
      other_v = CP::Vec2.new(2,2)

      v.distsq(other_v).should be_close(2, 0.001)
    end

    it 'can tell if its near? another vec2' do
      v = CP::Vec2.new(1,1)
      other_v = CP::Vec2.new(2,2)
      v.near?(other_v, 1).should be_false
      v.near?(other_v, 2).should be_true
    end

    it 'can rotate' do 
      v = CP::Vec2.new(2,3)
      other_v = CP::Vec2.new(4,5)
      rv = v.rotate(other_v)
      rv.x.should be_close(-7,0.001)
      rv.y.should be_close(22,0.001)
    end

    it 'can unrotate' do 
      v = CP::Vec2.new(2,3)
      other_v = CP::Vec2.new(4,5)
      rv = v.unrotate(other_v)
      rv.x.should be_close(23,0.001)
      rv.y.should be_close(2,0.001)
    end

    it 'can perp' do
      v = CP::Vec2.new(0,1)
      pv = v.perp
      pv.x.should be_close(-1,0.001)
      pv.y.should be_close(0,0.001)
    end

    it 'can rperp' do
      v = CP::Vec2.new(0,1)
      pv = v.rperp
      pv.x.should be_close(1,0.001)
      pv.y.should be_close(0,0.001)
    end

    it 'can lerp' do
      v = CP::Vec2.new(2,3)
      other_v = CP::Vec2.new(4,5)
      rv = v.lerp(other_v)
      rv.x.should be_close(-1.925,0.001)
      rv.y.should be_close(-0.925,0.001)
    end

    it 'can lerpconst' do
      v = CP::Vec2.new(2,3)
      other_v = CP::Vec2.new(4,5)
      rv = v.lerpconst(other_v, 6)
      rv.x.should be_close(4,0.001)
      rv.y.should be_close(5,0.001)
    end
    
    it 'can project' do
      v = CP::Vec2.new(2,3)
      other_v = CP::Vec2.new(4,5)
      rv = v.project(other_v)
      rv.x.should be_close(2.244,0.001)
      rv.y.should be_close(2.804,0.001)
    end

  end
end
