module CP

  class PivotJointStruct < NiceFFI::Struct
    layout(:constraint, ConstraintStruct,
             :anchr1, Vect,
             :anchr2, Vect,
             :r1, Vect,
             :r2, Vect,
             :k1, Vect,
             :k2, Vect,
             :j_acc, Vect,
             :j_max, CP_FLOAT,
             :bias, CP_FLOAT)
  end
  func :cpPivotJointNew, [:pointer, :pointer, Vect.by_value], :pointer
  func :cpPivotJointNew2, [:pointer, :pointer, Vect.by_value, Vect.by_value], :pointer

  class PivotJoint
    attr_reader :struct
    def initialize(a_body, b_body, anchr_one, anchr_two=nil)
      if anchr_two.nil?
        @struct = ConstraintStruct.new(CP.cpPivotJointNew(
          a_body.struct.pointer,b_body.struct.pointer,anchr_one.struct))
      else
        @struct = ConstraintStruct.new(CP.cpPivotJointNew2(
          a_body.struct.pointer,b_body.struct.pointer,anchr_one.struct,anchr_two.struct))
      end
    end
  end
end
