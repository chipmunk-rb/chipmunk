module CP
  callback :cpConstraintPreStepFunction, [:pointer, CP_FLOAT, CP_FLOAT], :void
  callback :cpConstraintApplyImpulseFunction, [:pointer], :void
  callback :cpConstraintGetImpulseFunction, [:pointer], CP_FLOAT

  class ConstraintClassStruct < NiceFFI::Struct
    layout(:pre_step, :cpConstraintPreStepFunction,
      :apply_impluse, :cpConstraintApplyImpulseFunction,
      :getImpulse, :cpConstraintGetImpulseFunction)
  end

  class ConstraintStruct < NiceFFI::Struct
    layout(:klass, :pointer,
           :a, :pointer,
           :b, :pointer,
           :max_force, CP_FLOAT,
           :max_bias, CP_FLOAT,
           :data, :pointer)
  end

  require 'chipmunk-ffi/constraints/pin_joint'
  require 'chipmunk-ffi/constraints/slide_joint'
#  require 'chipmunk-ffi/constraints/pivot_joint'
#  require 'chipmunk-ffi/constraints/groove_joint'
#  require 'chipmunk-ffi/constraints/damped_spring'
#  require 'chipmunk-ffi/constraints/rotary_limit_joint'
#  require 'chipmunk-ffi/constraints/ratchet_joint'
#  require 'chipmunk-ffi/constraints/gear_joint'
#  require 'chipmunk-ffi/constraints/simple_motor'
end
