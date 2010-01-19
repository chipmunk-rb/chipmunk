module CP

  class GearJointStruct < NiceFFI::Struct
    layout(:constraint, ConstraintStruct,
             :phase, CP_FLOAT,
             :ratio, CP_FLOAT,
             :ratio_inv, CP_FLOAT,
             :i_sum, CP_FLOAT,
             :bias, CP_FLOAT,
             :j_acc, CP_FLOAT,
             :j_max, CP_FLOAT)
  end
  func :cpGearJointNew, [:pointer, :pointer, CP_FLOAT, CP_FLOAT], :pointer

  class GearJoint
    attr_reader :struct
    def initialize(a_body, b_body, phase, ratio)
      @struct = GearJointStruct.new(CP.cpGearJointNew(
        a_body.struct.pointer,b_body.struct.pointer,phase, ratio))
    end
  end
end
