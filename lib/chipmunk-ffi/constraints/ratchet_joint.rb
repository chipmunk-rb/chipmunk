module CP

  class RatchetJointStruct < NiceFFI::Struct
    layout(:constraint, ConstraintStruct,
             :angle, CP_FLOAT,
             :phase, CP_FLOAT,
             :ratchet, CP_FLOAT,
             :i_sum, CP_FLOAT,
             :bias, CP_FLOAT,
             :j_acc, CP_FLOAT,
             :j_max, CP_FLOAT)
  end
  func :cpRatchetJointNew, [:pointer, :pointer, CP_FLOAT, CP_FLOAT], :pointer

  class RatchetJoint
    attr_reader :struct
    def initialize(a_body, b_body, phase, ratchet)
      @struct = RatchetJointStruct.new(CP.cpRatchetJointNew(
        a_body.struct.pointer,b_body.struct.pointer,phase,ratchet))
    end
  end
end
