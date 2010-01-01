module CP
  # FIXME tell Scott Lembcke that this function is missing from chipmunk_ffi.h
  # cp_static_inline :cpArbiterIsFirstContact, [:pointer], :int
  
  cp_static_inline :cpArbiterGetNormal, [:pointer, :int], Vect.by_value
  cp_static_inline :cpArbiterGetPoint, [:pointer, :int], Vect.by_value
  
  func :cpArbiterTotalImpulse, [:pointer], Vect.by_value
  func :cpArbiterTotalImpulseWithFriction, [:pointer], Vect.by_value
  
  class ArbiterStruct < NiceFFI::Struct
    layout(
      :num_contacts, :int,
      :contacts, :pointer,
      :a, :pointer,
      :b, :pointer,
      :e, CP_FLOAT,
      :u, CP_FLOAT,
      :surf_vr, Vect.by_value,
      :stamp, :int,
      :handler, :pointer,
      :swapped_col, :char,
      :first_col, :char
    )
  end
  
  class Arbiter
    attr_reader :struct
    def initialize(ptr)
      @struct = ArbiterStruct.new(ptr)
      @shapes = nil
      
      # temporary workaround for a bug in chipmunk
      @struct.num_contacts = 0 if @truct.contancts.null?
    end
    
    def first_contact?
      # CP.cpArbiterIsFirstContact(@struct.pointer).nonzero?
      @struct.first_col.nonzero?
    end
    
    def point(index = 0)
      raise IndexError unless (0...@struct.num_contacts).include? index
      Vec2.new CP.cpArbiterGetPoint(@struct.pointer, index)
    end
    
    def normal(index = 0)
      raise IndexError unless (0...@struct.num_contacts).include? index
      Vec2.new CP.cpArbiterGetNormal(@struct.pointer, index)
    end
    
    def impulse with_friction = false
      if with_friction
        Vec2.new CP.cpArbiterTotalImpulseWithFriction(@struct.pointer)
      else
        Vec2.new CP.cpArbiterTotalImpulse(@struct.pointer)
      end
    end
    
    def shapes
      return @shapes if @shapes

      swapped = @struct.swapped_col.nonzero?
      arba = swapped ? @struct.b : @struct.a
      arbb = swapped ? @struct.a : @struct.b

      as = ShapeStruct.new(arba)
      a_obj_id = as.data.get_long 0
      rb_a = ObjectSpace._id2ref a_obj_id

      bs = ShapeStruct.new(arbb)
      b_obj_id = bs.data.get_long 0
      rb_b = ObjectSpace._id2ref b_obj_id

      @shapes = [ rb_a, rb_b ]
    end
    
    def a
      self.shapes[0]
    end
    
    def b
      self.shapes[1]
    end
    
    def e
      @struct.e
    end
    def e=(new_e)
      @struct.e = new_e
    end
    
    def u
      @struct.u
    end
    def u=(new_u)
      @struct.u = new_u
    end
    
    def each_contact &block
      # TODO figure out FFI pointers and implement this (low priority)
      raise NotImplementedError, "Not implemented yet"
    end
  end
  
end

