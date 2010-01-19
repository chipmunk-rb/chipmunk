require File.dirname(__FILE__)+'/spec_helper'
describe 'Constraints in chipmunk' do
  describe 'PinJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::PinJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2)
    end
  end

  describe 'SlideJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::SlideJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2,4,6)
    end
  end

  describe 'PivotJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::PivotJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2)
    end
  end

  describe 'GrooveJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::GrooveJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2,ZERO_VEC_2)
    end
  end

  describe 'DampedSpring class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::DampedSpring.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2,3,4,5)
    end
  end

  describe 'RotaryLimitJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::RotaryLimitJoint.new(boda,bodb,Math::PI,Math::PI/2)
    end
  end

  describe 'RatchetJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::RatchetJoint.new(boda,bodb,3,4)
    end
  end
  
  describe 'GearJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::GearJoint.new(boda,bodb,1,2)
    end
  end

  describe 'SimpleMotor class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::SimpleMotor.new(boda,bodb,2)
    end
  end
end
