require File.dirname(__FILE__)+'/spec_helper'


describe 'Constraints in chipmunk' do
  let(:boda) { Body.new 90, 46 }
  let(:bodb) { Body.new 9, 6 }
  describe 'Constraints module' do
    
    let(:con) { CP::Constraint::PinJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2) }
    
    it 'can access body_a' do
      con.body_a.should == boda
    end
    
    it 'can access body_b' do
      con.body_b.should == bodb
    end
    
    it 'can access max_force' do
      con.max_force.should == CP::INFINITY
    end

    it 'can set max_force' do
      con.max_force = 12
      con.max_force.should == 12
    end
    
    it 'can access error_bias' do
      con.error_bias.should be_within(0.0001).of((1.0 - 0.1) ** 60)
    end

    it 'can set error_bias' do
      con.error_bias = 0.8
      con.error_bias.should == 0.8
    end
    
    it 'can access max_bias' do
      con.max_bias.should == CP::INFINITY 
    end    
    
    it 'can set max_bias' do
      con.max_bias = 200
      con.max_bias.should == 200
    end
    
    it 'can access its impulse' do
      con.impulse.should == 0.0 
    end  

    context "in a space" do
      let(:space) { CP::Space.new }
      before do
        space.add_body(boda)
        space.add_body(bodb)
        space.add_constraint(con)
      end

      it 'can set pre solve func with no args' do
        called = false
        con.pre_solve do
          called = true
        end

        space.step 1
        called.should be_true
      end

      it 'can set pre solve func with space arg' do
        called = false
        con.pre_solve do |space|
          called = true
          space.should == space
        end

        space.step 1
        called.should be_true
      end

      it 'can set post solve func with no args' do
        called = false
        con.post_solve do
          called = true
        end

        space.step 1
        called.should be_true
      end

      it 'can set post solve func with space arg' do
        called = false
        con.post_solve do |space|
          called = true
          space.should == space
        end

        space.step 1
        called.should be_true
      end

      it 'calls pre then post' do
        calls = []
        con.pre_solve do
          calls << :pre
        end
        con.post_solve do
          calls << :post
        end
        space.step 1

        calls.should == [:pre, :post]

      end
    end

  end
  
  describe 'PinJoint class' do
    it 'can be created' do
      CP::Constraint::PinJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2)
    end

    it 'can set / get anchr1' do
      c = CP::Constraint::PinJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2)
      v = vec2(4,5)
      c.anchr1 = v
      c.anchr1.should == v
    end

    it 'can set / get anchr2' do
      c = CP::Constraint::PinJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2)
      v = vec2(4,5)
      c.anchr2 = v
      c.anchr2.should == v
    end

    it 'can set / get dist' do
      c = CP::Constraint::PinJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2)
      c.dist = 3
      c.dist.should == 3
    end
    
    it "won't crash when created incorrectly" do
      lambda { CP::Constraint::PinJoint.new }.should raise_error
    end
  end  
  

  describe 'SlideJoint class' do
    let(:constraint) { CP::Constraint::SlideJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2,4,6) }

    it 'can set / get anchr1' do
      v = vec2(4,5)
      constraint.anchr1 = v
      constraint.anchr1.should == v
    end

    it 'can set / get anchr2' do
      v = vec2(4,5)
      constraint.anchr2 = v
      constraint.anchr2.should == v
    end

    it 'can set / get min' do
      constraint.min = 2
      constraint.min.should == 2
    end

    it 'can set / get max' do
      constraint.max = 2
      constraint.max.should == 2
    end
  end

  describe 'PivotJoint class' do
    it 'can be created with two vectors' do
      CP::Constraint::PivotJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2)
    end

    it 'can be created with one vector' do
      CP::Constraint::PivotJoint.new(boda,bodb,ZERO_VEC_2)
    end

    it 'can set / get anchr1' do
      c = CP::Constraint::PivotJoint.new(boda,bodb,ZERO_VEC_2)
      v = vec2(4,5)
      c.anchr1 = v
      c.anchr1.should == v
    end

    it 'can set / get anchr2' do
      c = CP::Constraint::PivotJoint.new(boda,bodb,ZERO_VEC_2)
      v = vec2(4,5)
      c.anchr2 = v
      c.anchr2.should == v
    end
  end

  describe 'GrooveJoint class' do
    let(:constraint) { CP::Constraint::GrooveJoint.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2,ZERO_VEC_2) }

    check_accessor :constraint, :groove_a, vec2(1,2)
    check_accessor :constraint, :groove_b, vec2(1,2)
    check_accessor :constraint, :anchr2, vec2(1,2)
  end

  describe 'DampedSpring class' do
    let(:constraint) { CP::Constraint::DampedSpring.new(boda,bodb,ZERO_VEC_2,ZERO_VEC_2,3,4,5) }
    it 'can be created' do
      constraint      
    end

    check_accessor :constraint, :anchr1, vec2(1,2)
    check_accessor :constraint, :anchr2, vec2(1,2)
    check_accessor :constraint, :rest_length, 12.0
    check_accessor :constraint, :stiffness, 1.0
    check_accessor :constraint, :damping, 3.3

    it 'allows setting of spring force func' do
      space = CP::Space.new
      space.add_body boda
      space.add_body bodb

      space.add_constraint constraint
      called = false
      called_dist = nil
      constraint.force do |dist|
        called = true
        called_dist = dist
      end

      space.step 1
      called.should be_true
      called_dist.should == 0.0
    end
  end

  describe 'DampedRotarySpring class' do
    let(:constraint) { CP::Constraint::DampedRotarySpring.new(boda,bodb,0,1.0,0.5) }

    check_accessor :constraint, :rest_angle, 32.2
    check_accessor :constraint, :stiffness, 1.0
    check_accessor :constraint, :damping, 3.3

    it 'allows setting of spring torque func' do
      pending "CP_DefineConstraintProperty(cpDampedRotarySpring, cpDampedRotarySpringTorqueFunc, springTorqueFunc, SpringTorqueFunc)"
    end
  end
  
  describe 'RotaryLimitJoint class' do
    let(:constraint) { 
      CP::Constraint::RotaryLimitJoint.new(boda,bodb,Math::PI,Math::PI/2)
    }

    check_accessor :constraint, :min, 32.2
    check_accessor :constraint, :max, 1.0
  end

  describe 'RatchetJoint class' do
    it 'can be created' do
    end
  end

  describe 'RatchetJoint class' do
    let(:constraint) { 
      CP::Constraint::RatchetJoint.new(boda,bodb,3,4)
    }

    check_accessor :constraint, :angle, 32.2
    check_accessor :constraint, :phase, 1.3
    check_accessor :constraint, :ratchet, 4.4
  end
  
  describe 'GearJoint class' do
    let(:constraint) { 
      CP::Constraint::GearJoint.new(boda,bodb,1,2)
    }

    check_accessor :constraint, :phase, 32.2
    check_accessor :constraint, :ratio, 2.2
  end

  describe 'SimpleMotor class' do
    let(:constraint) { 
      CP::Constraint::SimpleMotor.new(boda,bodb,2)
    }

    check_accessor :constraint, :rate, 300.1
  end
end
