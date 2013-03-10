require File.dirname(__FILE__)+'/spec_helper'


describe 'Constraints in chipmunk' do
  describe 'Constraints module' do
    
    before(:each) do
      @boda = Body.new 90, 46
      @bodb = Body.new 9, 6
      @con  = CP::Constraint::PinJoint.new(@boda,@bodb,ZERO_VEC_2,ZERO_VEC_2)    
    end
    
    it 'can access body_a' do
      @con.body_a.should == @boda
    end
    
    it 'can access body_b' do
      @con.body_b.should == @bodb
    end
    
    it 'can access max_force' do
      @con.max_force.should == CP::INFINITY
    end
    
    it 'can access error_bias' do
      @con.error_bias.should be_within(0.0001).of((1.0 - 0.1) ** 60)
    end
    
    it 'can access max_bias' do
      @con.max_bias.should == CP::INFINITY 
    end    
    
    it 'can access its impulse' do
      @con.impulse.should == 0.0 
    end  

  end
  
  describe 'PinJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::Constraint::PinJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2)
    end
    
    it "won't crash when created incorrectly" do
      lambda { CP::Constraint::PinJoint.new }.should raise_error
    end
  end  
  

  describe 'SlideJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::Constraint::SlideJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2,4,6)
    end
  end

  describe 'PivotJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::Constraint::PivotJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2)
    end
  end

  describe 'GrooveJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::Constraint::GrooveJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2,ZERO_VEC_2)
    end
  end

  describe 'DampedSpring class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::Constraint::DampedSpring.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2,3,4,5)
    end
  end
  
  describe 'DampedRotarySpring class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::Constraint::DampedRotarySpring.new(boda,bodb,0,1.0,0.5)
    end
  end
  

  describe 'RotaryLimitJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::Constraint::RotaryLimitJoint.new(boda,bodb,Math::PI,Math::PI/2)
    end
  end

  describe 'RatchetJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::Constraint::RatchetJoint.new(boda,bodb,3,4)
    end
  end
  
  describe 'GearJoint class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::Constraint::GearJoint.new(boda,bodb,1,2)
    end
  end

  describe 'SimpleMotor class' do
    it 'can be created' do
      boda = Body.new 90, 46
      bodb = Body.new 9, 6
      CP::Constraint::SimpleMotor.new(boda,bodb,2)
    end
  end
end
