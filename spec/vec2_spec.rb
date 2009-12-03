require File.dirname(__FILE__)+'/spec_helper'
describe 'Vect in chipmunk' do
  describe 'vec2 global method' do
    v = vec2(4,3)
    v.class.should == CP::Vec2
    v.x.should == 4
    v.y.should == 3
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
  end
end
