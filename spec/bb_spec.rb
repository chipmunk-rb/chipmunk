require File.dirname(__FILE__)+'/spec_helper'
describe 'BB Bounds Box in chipmunk' do
  describe 'BB class' do
    it 'can be created by l,b,r,t' do
      bb = CP::BB.new(1,2,3,4)
      bb.l.should == 1
      bb.b.should == 2
      bb.r.should == 3
      bb.t.should == 4
    end
    
    it 'can intersect with other boxes' do
      bb1 = CP::BB.new(1,2,3,4)
      bb2 = CP::BB.new(1.5,2.5,3.5,4.5)
      bb1.intersect?(bb2).should be_true
    end
    
    it 'can check for containment of other boxes' do
      bb1 = CP::BB.new(1,2,3,4)
      bb2 = CP::BB.new(1.5,2.5,2.9,3.9)
      bb1.contain_bb?(bb2).should be_true
      bb1.contains_bb?(bb2).should be_true
      bb1.contain?(bb2).should be_true
      bb1.contains?(bb2).should be_true
    end
    
    it 'can check for containment of vectors' do
      bb1 = CP::BB.new(1,2,3,4)
      vec = CP::Vec2.new(1.5,2.5)
      bb1.contain_vect?(vec).should be_true
      bb1.contains_vect?(vec).should be_true
      bb1.contain?(vec).should be_true
      bb1.contains?(vec).should be_true
    end
    
    it 'can merge bound boxes' do
      bb1 = CP::BB.new(1,2,3,4)
      bb2 = CP::BB.new(1.5,2.5,3.5,4.5)
      rbb = bb1.merge(bb2)
      rbb.l.should == 1
      rbb.r.should == 3.5
      rbb.t.should == 4.5
      rbb.b.should == 2.0
    end
    
    it 'can expand bound boxes' do
      bb1 = CP::BB.new(1,2,3,4)
      vec = CP::Vec2.new(4,5)
      rbb = bb1.expand(vec)
      rbb.l.should == 1
      rbb.r.should == 4.0
      rbb.t.should == 5.0
      rbb.b.should == 2.0
    end
    
    it 'can clamp vectors' do
      bb  = CP::BB.new(1,2,3,4)
      vec = CP::Vec2.new(10,-10)
      vr  = bb.clamp_vect(vec)
      vr.x.should be_within(0.001).of(3.0) 
      vr.y.should be_within(0.001).of(2.0)
    end
    
    it 'can wrap vectors' do
      bb  = CP::BB.new(1,2,3,4)
      vec = CP::Vec2.new(10,-10)
      vr  = bb.wrap_vect(vec)
      vr.x.should be_within(0.001).of(2.0) 
      vr.y.should be_within(0.001).of(4.0)
    end
    
    
    
  end
end
