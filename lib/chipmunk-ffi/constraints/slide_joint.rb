module CP

  class SlideJointStruct < NiceFFI::Struct
    layout(:constraint, ConstraintStruct,
             :anchr1, Vect,
             :anchr2, Vect,
             :min, CP_FLOAT,
             :max, CP_FLOAT,
             :r1, Vect,
             :r2, Vect,
             :n, Vect,
             :n_mass, CP_FLOAT,
             :jn_acc, CP_FLOAT,
             :jn_max, CP_FLOAT,
             :bias, CP_FLOAT)
  end

  func :cpSlideJointNew, [:pointer, :pointer, Vect.by_value, Vect.by_value, CP_FLOAT, CP_FLOAT], :pointer

  class SlideJoint
    attr_reader :struct
    def initialize(a_body, b_body, anchr_one, anchr_two, min, max)
      @struct = ConstraintStruct.new(CP.cpSlideJointNew(
        a_body.struct.pointer,b_body.struct.pointer,anchr_one.struct,anchr_two.struct,min,max))
    end
  end
end
