module CP

  class RotaryLimitJointStruct < NiceFFI::Struct
    layout(:constraint, ConstraintStruct,
             :min, CP_FLOAT,
             :max, CP_FLOAT,
             :i_sum, CP_FLOAT,
             :bias, CP_FLOAT,
             :j_acc, CP_FLOAT,
             :j_max, CP_FLOAT)
  end
  func :cpRotaryLimitJointNew, [:pointer, :pointer, CP_FLOAT, CP_FLOAT], :pointer

  class RotaryLimitJoint
    attr_reader :struct
    def initialize(a_body, b_body, min, max)
      @struct = RotaryLimitJointStruct.new(CP.cpRotaryLimitJointNew(
        a_body.struct.pointer,b_body.struct.pointer,min,max))
    end
  end
end
