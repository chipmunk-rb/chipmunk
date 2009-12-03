require File.dirname(__FILE__)+'/spec_helper'
describe 'BBStruct in chipmunk' do
  describe 'BB class' do
    it 'can be created by l,b,r,t' do
      bb = CP::BB.new(1,2,3,4)
      bb.l.should == 1
      bb.b.should == 2
      bb.r.should == 3
      bb.t.should == 4
    end
  end
end
