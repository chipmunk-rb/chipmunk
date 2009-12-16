module CP

  class SimpleMotorStruct < NiceFFI::Struct
    layout(:constraint, ConstraintStruct,
             :rate, CP_FLOAT,
             :i_sum, CP_FLOAT,
             :j_acc, CP_FLOAT,
             :j_max, CP_FLOAT)
  end
  func :cpSimpleMotorNew, [:pointer, :pointer, CP_FLOAT], :pointer

  class SimpleMotor
    attr_reader :struct
    def initialize(a_body, b_body, rate)
      @struct = SimpleMotorStruct.new(CP.cpSimpleMotorNew(
        a_body.struct.pointer,b_body.struct.pointer,rate))
    end
  end
end
