require File.dirname(__FILE__)+'/spec_helper'
describe 'Shapes in chipmunk' do
  describe 'Circle class' do
    
    it 'can be created' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
    end
    
    it 'can be created with a nil offset' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, nil
    end
    
    it 'can be created with a missing offset' do
       bod = CP::Body.new 90, 76
       s = CP::Shape::Circle.new bod, 40
    end
    
    it 'does not crash if created incorrectly' do      
      lambda { s = CP::Shape::Circle.new }.should raise_error
    end

    it 'cannot be created' do
      bod = CP::Body.new 90, 76
      lambda { s = CP::Shape::Circle.new(bod) }.should raise_error
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
    
    it 'can get a BB that is not updated' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      bb = s.raw_bb
      bb.should_not be_nil
      # raw bb is only useful for performance reasons.
      bb.l.should == 0 
      bb.b.should == 0
      bb.r.should == 0
      bb.t.should == 0
    end


    it 'can get its layers' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      # he sets layers to -1 on an unsigned int
      s.layers.should == CP::ALL_LAYERS
    end

    it 'can set its layers' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      s.layers = 5
      s.layers.should == 5
    end
    
    it 'can get its group' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      # Nil, because not set before
      s.group.should == nil
    end
    
    it 'can set its group' do
      class Aid; end
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      # Nil, because not set before
      s.group = Aid 
      s.group = Aid 
      s.group.should == Aid

      s.group = :other
      s.group.should == :other
    end


    it 'can get its col type' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      s.collision_type.should == nil
      s.collision_type = :foo
      s.collision_type.should == :foo
    end

    it 'can get its sensor' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      s.sensor?.should be_false
      s.sensor = true
      s.sensor?.should be_true
    end

    it 'can get its u' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      s.u.should be_within(0.001).of(0)
    end

    it 'can get its surf vec' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      s.surface_v = vec2(4,5)
      s.surface_v.x.should be_within(0.001).of(4)
      s.surface_v.y.should be_within(0.001).of(5)
    end

    it 'can get its data' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      s.data.should == s
      # s.data.read_long.should == s.object_id
      # Chipmunk stores the shape object itself in data
    end

    # Do we need this?
=begin    
    it 'can get its klass' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 40, CP::ZERO_VEC_2
      ShapeClassStruct.new(s.struct.klass).type.should == :circle_shape      
    end
=end    

    it 'can set its bodys v' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 20, CP::ZERO_VEC_2
      s.body.v = vec2(4,5)
    end

    it 'can set its sensory-ness' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 20, CP::ZERO_VEC_2
      s.sensor?.should be_false
      s.sensor = true
      s.sensor?.should be_true
    end

    it 'can query if a point hits it' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 20, CP::ZERO_VEC_2
      s.point_query(vec2(0,10)).should be_true
      s.point_query(vec2(0,100)).should be_false
    end

    it 'can query if a segment hits it' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 20, CP::ZERO_VEC_2
      info = s.segment_query(vec2(-100,10),vec2(0,10))
      GC.start
      info.shape.should be_true
      info.shape.should == s
      info.t.should be_within(0.001).of(0.827)
      info.n.x.should be_within(0.001).of(-0.866)
      info.n.y.should be_within(0.001).of(0.5)
      info.class.should == CP::SegmentQueryInfo
    end

    it 'can query nearest point' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 20, CP::ZERO_VEC_2
      info = s.nearest_point_query(vec2(100, 100))
      GC.start
      info.shape.should be_true
      info.shape.should == s

      info.d.should be_within(0.001).of(121.421)
      info.p.x.should be_within(0.001).of(14.142)
      info.p.y.should be_within(0.001).of(14.142)
      info.class.should == CP::NearestPointQueryInfo
    end

    it 'can get its radius' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 20, CP::ZERO_VEC_2
      s.radius.should == 20
    end
      
    it 'can get its offset' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 20, CP::ZERO_VEC_2
      v = s.offset       
      v.x.should == 0
      v.y.should == 0
    end
    
    it "can unsafely modify its radius" do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 20, CP::ZERO_VEC_2
      s.set_radius! 7
      s.r.should == 7
    end

    it "can unsafely modify its offset" do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Circle.new bod, 20, CP::ZERO_VEC_2
      s.set_offset! vec2(1,2)
      s.offset.should == vec2(1,2)
    end

  end
  
  describe 'SegmentQueryInfo struct' do
    it 'can be created manually' do
      data = CP::SegmentQueryInfo.new(1, 2, 3)
      data.shape.should == 1
      data.t.should == 2
      data.n.should == 3
    end    
  end

  describe 'Segment class' do
    it 'can be created' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Segment.new bod, vec2(1,1), vec2(2,2), 5
    end
    
    it 'can get its a' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Segment.new bod, vec2(1,2), vec2(3,4), 5
      v = s.a
      v.x.should == 1
      v.y.should == 2
    end
    
    it 'can get its b' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Segment.new bod, vec2(1,2), vec2(3,4), 5
      v = s.b
      v.x.should == 3
      v.y.should == 4
    end
    
    it 'can get its radius' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Segment.new bod, vec2(1,2), vec2(3,4), 5
      r = s.radius
      r.should == 5
    end
    
    it 'can get its normal' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Segment.new bod, vec2(1,2), vec2(3,4), 5
      v = s.normal
      v.x.should be_within(0.001).of(-0.70710) 
      v.y.should be_within(0.001).of( 0.70710)
    end
    
    it "can unsafely modify its endpoints" do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Segment.new bod, vec2(1,2), vec2(3,4), 5
      s.set_endpoints!(vec2(3,4), vec2(1,2))
      s.a.should == vec2(3,4)
      s.b.should == vec2(1,2)
    end

    it "can unsafely modify its radius" do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Segment.new bod, vec2(1,2), vec2(3,4), 5
      s.set_radius! 7
      s.r.should == 7
    end

    it 'can unsafely modify its neighbors' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Segment.new bod, vec2(1,2), vec2(3,4), 5
      s.set_neighbors! vec2(5,6), vec2(7,8)
    end
    
  end
  
  describe 'Poly class' do
    it 'can create box from width / height' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Poly.box(bod, 22, 40)
      s.class.should == CP::Shape::Poly
      s.num_verts.should == 4
      s[0].x.should == -11
      s[0].y.should == -20
      s[1].x.should == -11
      s[1].y.should == 20
      s[2].x.should == 11
      s[2].y.should == 20
      s[3].x.should == 11
      s[3].y.should == -20
    end

    it 'can create box from BB' do
      bod = CP::Body.new 90, 76
      bb = CP::BB.new(-11, -20, 11, 20)
      s = CP::Shape::Poly.box(bod, bb)
      s.num_verts.should == 4
      s[0].x.should == -11
      s[0].y.should == -20
      s[1].x.should == -11
      s[1].y.should == 20
      s[2].x.should == 11
      s[2].y.should == 20
      s[3].x.should == 11
      s[3].y.should == -20
    end

    it 'can validate polygon points' do
      points  = [vec2(1,1), vec2(2,2),vec2(3,3)]
      res     = CP::Shape::Poly.valid? points
      res.should be_true
    end
    
    it 'can be created' do
      bod = CP::Body.new 90, 76
      s   = CP::Shape::Poly.new bod, [vec2(1,1), vec2(2,2),vec2(3,3)], CP::ZERO_VEC_2
    end
    
    it 'can be created with a nil offset' do
      bod = CP::Body.new 90, 76
      s   = CP::Shape::Poly.new bod, [vec2(1,1), vec2(2,2),vec2(3,3)], nil
    end
    
    it 'can be created without an offset' do
      bod = CP::Body.new 90, 76
      s   = CP::Shape::Poly.new bod, [vec2(1,1), vec2(2,2),vec2(3,3)]
    end
    
    
    it 'can get its amount of vertices' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Poly.new bod, [vec2(1,1), vec2(2,2),vec2(3,3)], CP::ZERO_VEC_2
      s.size.should == 3
    end
    
    it 'can get vertices' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Poly.new bod, [vec2(1,1), vec2(2,2),vec2(3,3)], CP::ZERO_VEC_2
      v = s[1]
      v.x.should == 2
      v.y.should == 2
    end
    
    it 'returns nil if vertex is out of range' do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Poly.new bod, [vec2(1,1), vec2(2,2),vec2(3,3)], CP::ZERO_VEC_2
      v = s[22]
      v.should be_nil
    end
    
    it "can unsafely modify its vertices" do
      bod = CP::Body.new 90, 76
      s = CP::Shape::Poly.new bod, [vec2(1,1), vec2(2,2),vec2(3,3)], CP::ZERO_VEC_2
      s.set_verts!([vec2(1,1), vec2(2,2), vec2(3,3), vec2(4,4)], CP::ZERO_VEC_2)
      s.size.should == 4
      v = s[3]
      v.x.should == 4
      v.y.should == 4      
    end
  end
  
  
  describe 'Shape class' do
    it 'can have an arbitrary object connected to it' do
      b  = CP::Body.new(5, 7)
      s  = CP::Shape::Segment.new b, vec2(1,1), vec2(2,2), 5
      o  = "Hello"
      s.object = o
      s.object.should == o
    end
      
    it 'can reset the id counter' do
      lambda { CP::Shape.reset_id_counter }.should_not raise_error 
    end
  
  end


end
