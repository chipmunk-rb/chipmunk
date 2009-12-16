require File.dirname(__FILE__)+'/spec_helper'
describe 'Constraints in chipmunk' do
  describe 'PinJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      pj = CP::PinJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2)
    end
  end

  describe 'SlideJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      sj = CP::SlideJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2,4,6)
    end
  end
end
