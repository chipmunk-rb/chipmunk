module CP
  class CollisionHandlerStruct < NiceFFI::Struct
    layout(
      :a, :uint,
      :b, :uint,
      :begin, :pointer,
      :pre_solve, :pointer,
      :post_solve, :pointer,
      :separate, :pointer,
      :data, :pointer
    )
  end

  class SpaceStruct < NiceFFI::Struct
    layout( :iterations, :int,
      :elestic_iterations, :int,
      :gravity, Vect.by_value,
      :damping, CP_FLOAT,
      :stamp, :int,
      :static_shapes, :pointer,
      :active_shapes, :pointer,
      :bodies, :pointer,
      :arbiters, :pointer,
      :contact_set, :pointer,
      :constraints, :pointer,
      :coll_func_set, :pointer,
      :default_handler, :pointer,
      :post_step_callbacks, :pointer
    )
    def self.release(ptr)
      CP.cpSpaceFreeChildren(ptr)
    end
  end

  callback :cpCollisionBeginFunc, [:pointer,:pointer,:pointer], :int
  callback :cpCollisionPreSolveFunc, [:pointer,:pointer,:pointer], :int
  callback :cpCollisionPostSolveFunc, [:pointer,:pointer,:pointer], :int
  callback :cpCollisionSeparateFunc, [:pointer,:pointer,:pointer], :int


  func :cpSpaceNew, [], :pointer
  func :cpSpaceFreeChildren, [:pointer], :void

  class Space
    attr_reader :struct
    def initialize(*args)
      case args.size
      when 0
        @struct = CP.cpSpaceNew()
        @static_shapes = []
        @active_shapes = []
        @bodies = []
        @constraints = []
        @blocks = {}
      when 1
        @struct = args.first
      else
        raise "wrong number of args for Space, got #{args.size}, but expected 0"
      end
    end
  end
end

