require File.dirname(__FILE__)+'/spec_helper'
describe 'ShapeStruct in chipmunk' do
  describe 'Circle class' do
    it 'can be created' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    end

    it 'can get its body' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 20, CP::ZERO_VEC_2
      s.body.should == bod
    end

    it 'can get its elasticity' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 20, CP::ZERO_VEC_2
      s.e.should == 0
      s.e = 0.5
      s.e.should == 0.5
    end

    it 'can build a BB' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      bb = s.bb
      bb.should_not be_nil
      bb.l.should == -40 
      bb.b.should == -40
      bb.r.should == 40
      bb.t.should == 40
    end

    it 'can get its layers' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      # he sets layers to -1 on an unsigned int
      s.layers.should == 2**32-1
    end

    it 'can get its group' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      s.struct.group.should == 0
    end

    it 'can get its col type' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      s.collision_type.should == nil
      s.collision_type = :foo
      s.collision_type.should == :foo
      s.struct.collision_type.should == :foo.object_id
    end

    it 'can get its sensor'
    it 'can get its u' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      s.u.should be_close(0,0.001)
    end
    it 'can get its surf vec'

    it 'can get its data' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      s.data.read_int.should == s.object_id
    end

    it 'can get its klass' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      ShapeClassStruct.new(s.struct.klass).type.should == :circle_shape
    end
  end
  describe 'Segment class' do
    it 'can be created' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Segment.new bod, vec2(1,1), vec2(2,2), 5
    end
  end
  describe 'Poly class' do
    it 'can be created' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Poly.new bod, [vec2(1,1), vec2(2,2),vec2(3,3)], CP::ZERO_VEC_2
    end
  end
end
