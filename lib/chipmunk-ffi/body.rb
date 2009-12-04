module CP

  callback :cpBodyVelocityFunc, [:pointer, Vect.by_value, CP_FLOAT, CP_FLOAT], :void
  callback :cpBodyPostitionFunc, [:pointer, CP_FLOAT], :void

  class BodyStruct < NiceFFI::Struct
    layout(
      #      :bodyVelocityFunc, :cpBodyVelocityFunc,
      #      :bodyPositionFunc, :cpBodyPositionFunc,
      # TODO not sure if :pointer is right here...
      :bodyVelocityFunc, :pointer,
      :bodyPositionFunc, :pointer,
      :m, CP_FLOAT,
      :m_inv, CP_FLOAT,
      :i, CP_FLOAT,
      :i_inv, CP_FLOAT,
      :p, CP_FLOAT,
      :v, CP_FLOAT,
      :f, CP_FLOAT,
      :a, CP_FLOAT,
      :w, CP_FLOAT,
      :t, CP_FLOAT,
      :rot, Vect,
      :data, :pointer,
      :v_bias, Vect,
      :w_bias, CP_FLOAT
    )
#    def self.release(me)
#      CP.cpBodyDestroy me
#    end
  end
  func :cpBodyNew, [CP_FLOAT, CP_FLOAT], BodyStruct
  func :cpBodyDestroy, [BodyStruct], :void

  class Body
    attr_reader :struct
    def initialize(m,i)
      @ptr = CP.cpBodyNew m, i
      @struct = BodyStruct.new @ptr
    end

    def m
      @struct.m
    end
    def m=(pm)
      @struct.m = pm
    end
    def i
      @struct.i
    end
    def i=(pi)
      @struct.i = pi
    end
    def p
      @struct.p
    end
    def p=(pp)
      @struct.p = pp
    end
    def v
      @struct.v
    end
    def v=(pv)
      @struct.v = pv
    end
    def f
      @struct.f
    end
    def f=(pf)
      @struct.f = pf
    end
    def a
      @struct.a
    end
    def a=(pa)
      @struct.a = pa
    end
    def w
      @struct.w
    end
    def w=(pw)
      @struct.w = pw
    end
    def t
      @struct.t
    end
    def t=(pt)
      @struct.t = pt
    end
    def rot
      @struct.rot
    end
    def rot=(prot)
      @struct.rot = prot
    end

    alias :mass :m
    alias :moment :i
    alias :pos :p
    alias :vel :v
    alias :force :f
    alias :angle :a
    alias :ang_vel :w
    alias :torque :t

    alias :mass= :m=
    alias :moment= :i=
    alias :pos= :p=
    alias :vel= :v=
    alias :force= :f=
    alias :angle= :a=
    alias :ang_vel= :w=
    alias :torque= :t=
  end

end
=begin


  rb_define_method(c_cpBody, "local2world", rb_cpBodyLocal2World, 1);
  rb_define_method(c_cpBody, "world2local", rb_cpBodyWorld2Local, 1);

  rb_define_method(c_cpBody, "reset_forces", rb_cpBodyResetForces, 0);
  rb_define_method(c_cpBody, "apply_force", rb_cpBodyApplyForce, 2);
  rb_define_method(c_cpBody, "apply_impulse", rb_cpBodyApplyImpulse, 2);

  rb_define_method(c_cpBody, "update_velocity", rb_cpBodyUpdateVelocity, 3);
  rb_define_method(c_cpBody, "update_position", rb_cpBodyUpdatePosition, 1);
=end
