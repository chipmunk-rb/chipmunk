module CP

  callback :cpBodyVelocityFunc, [:pointer, Vect.by_value, CP_FLOAT, CP_FLOAT], :void
  callback :cpBodyPositionFunc, [:pointer, CP_FLOAT], :void

  class BodyStruct < NiceFFI::Struct
    layout(
      :bodyVelocityFunc, :cpBodyVelocityFunc,
      :bodyPositionFunc, :cpBodyPositionFunc,
      :m, CP_FLOAT,
      :m_inv, CP_FLOAT,
      :i, CP_FLOAT,
      :i_inv, CP_FLOAT,
      :p, Vect,
      :v, Vect,
      :f, Vect,
      :a, CP_FLOAT,
      :w, CP_FLOAT,
      :t, CP_FLOAT,
      :rot, Vect,
      :data, :pointer,
      :v_limit, CP_FLOAT,
      :w_limit, CP_FLOAT,
      :v_bias, Vect,
      :w_bias, CP_FLOAT
    )

    def self.release(me)
      # TODO is this right?
      CP.cpBodyDestroy me
    end
  end
  func :cpBodyNew, [CP_FLOAT, CP_FLOAT], BodyStruct
  func :cpBodyDestroy, [BodyStruct], :void
  func :cpBodyUpdateVelocity, [BodyStruct,Vect.by_value,CP_FLOAT,CP_FLOAT], :void
  func :cpBodyUpdatePosition, [BodyStruct,CP_FLOAT], :void
  func :cpBodyApplyForce, [:pointer, Vect.by_value, Vect.by_value], :void
  func :cpBodyResetForces, [:pointer], :void

  cp_static_inline :cpBodyLocal2World, [:pointer, Vect.by_value], Vect.by_value
  cp_static_inline :cpBodyWorld2Local, [:pointer, Vect.by_value], Vect.by_value
  cp_static_inline :cpBodyApplyImpulse, [:pointer, Vect.by_value, Vect.by_value], :void

  func :cpBodySetMass, [:pointer, CP_FLOAT], :void
  func :cpBodySetMoment, [:pointer, CP_FLOAT], :void
  func :cpBodySetAngle, [:pointer, CP_FLOAT], :void

  class Body
    attr_reader :struct
    def initialize(*args)
      case args.size
      when 1
        @struct = args.first
      when 2
        ptr = CP.cpBodyNew(*args)
        @struct = BodyStruct.new ptr
      else
        raise "wrong number of args for Body, got #{args.size}, but expected 2"
      end
    end

    def m
      @struct.m
    end
    def m=(pm)
      CP.cpBodySetMass(@struct.pointer, pm)
    end
    alias :mass :m
    alias :mass= :m=

    def m_inv
      @struct.m_inv
    end
    alias :mass_inv :m_inv

    def i
      @struct.i
    end
    def i=(pi)
      CP.cpBodySetMoment(@struct.pointer, pi)
    end
    alias :moment :i
    alias :moment= :i=

    def i_inv
      @struct.i_inv
    end
    alias :moment_inv :i_inv

    def p
      Vec2.new @struct.p
    end
    def p=(new_p)
      @struct.p.pointer.put_bytes 0, new_p.struct.to_bytes, 0,Vect.size
      self
    end
    alias :pos :p
    alias :pos= :p=

    def v
      Vec2.new @struct.v
    end
    def v=(pv)
      @struct.v.pointer.put_bytes 0, pv.struct.to_bytes, 0,Vect.size
      self
    end
    alias :vel :v
    alias :vel= :v=

    def f
      Vec2.new @struct.f
    end
    def f=(pf)
      @struct.f.pointer.put_bytes 0, pf.struct.to_bytes, 0,Vect.size
      self
    end
    alias :force :f
    alias :force= :f=

    def a
      @struct.a
    end
    def a=(pa)
      CP.cpBodySetAngle(@struct.pointer, pa)
    end
    alias :angle :a
    alias :angle= :a=

    def w
      @struct.w
    end
    def w=(pw)
      @struct.w = pw
    end
    alias :ang_vel :w
    alias :ang_vel= :w=

    def t
      @struct.t
    end
    def t=(pt)
      @struct.t = pt
    end
    alias :torque :t
    alias :torque= :t=

    def rot
      Vec2.new @struct.rot
    end

    def local2world(v)
      Vec2.new CP.cpBodyLocal2World(@struct.pointer,v.struct)
    end

    def world2local(v)
      Vec2.new CP.cpBodyWorld2Local(@struct.pointer,v.struct)
    end

    def reset_forces
      CP.cpBodyResetForces(@struct.pointer)
    end

    def apply_force(f,r)
      CP.cpBodyApplyForce(@struct.pointer,f.struct,r.struct)
    end

    def apply_impulse(j,r)
      CP.cpBodyApplyImpulse(@struct.pointer,j.struct,r.struct)
    end

    def update_velocity(g,dmp,dt)
      CP.cpBodyUpdateVelocity(@struct.pointer,g.struct,dmp,dt)
    end

    def update_position(dt)
      CP.cpBodyUpdatePosition(@struct.pointer,dt)
    end

  end
end
