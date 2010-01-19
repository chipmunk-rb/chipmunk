module CP

  class DampedSpringStruct < NiceFFI::Struct
    layout(:constraint, ConstraintStruct,
             :anchr1, Vect,
             :anchr2, Vect,
             :rest_length, CP_FLOAT,
             :stiffness, CP_FLOAT,
             :damping, CP_FLOAT,
             :damped_spring_force_fun, :pointer,
             :dt, CP_FLOAT,
             :target_vrn, CP_FLOAT,
             :r1, Vect,
             :r2, Vect,
             :n_mass, CP_FLOAT,
             :n, Vect)
  end

  func :cpDampedSpringNew, [:pointer, :pointer, Vect.by_value, Vect.by_value, CP_FLOAT, CP_FLOAT, CP_FLOAT], :pointer

  class DampedSpring
    attr_reader :struct
    def initialize(a_body, b_body, anchr_one, anchr_two, 
                   rest_length, stiffness, damping)
      @struct = DampedSpringStruct.new(CP.cpDampedSpringNew(
        a_body.struct.pointer,b_body.struct.pointer,anchr_one.struct,anchr_two.struct,
        rest_length, stiffness, damping))
    end
  end
end
