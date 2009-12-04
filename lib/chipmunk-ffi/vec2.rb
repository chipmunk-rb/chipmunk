module CP
  class Vect < NiceFFI::Struct
    layout( :x, CP_FLOAT,
           :y, CP_FLOAT )
  end

  cp_static_inline :cpv, [CP_FLOAT,CP_FLOAT], Vect.by_value
  cp_static_inline :cpvneg, [Vect.by_value], Vect.by_value
  cp_static_inline :cpvadd, [Vect.by_value,Vect.by_value], Vect.by_value
  cp_static_inline :cpvsub, [Vect.by_value,Vect.by_value], Vect.by_value
  cp_static_inline :cpvmult, [Vect.by_value,CP_FLOAT], Vect.by_value
  cp_static_inline :cpvdot, [Vect.by_value,Vect.by_value], Vect.by_value
  cp_static_inline :cpvcross, [Vect.by_value,Vect.by_value], Vect.by_value

  cp_static_inline :cpvperp, [Vect.by_value], Vect.by_value
  cp_static_inline :cpvrperp, [Vect.by_value], Vect.by_value
  cp_static_inline :cpvproject, [Vect.by_value,Vect.by_value], Vect.by_value
  cp_static_inline :cpvrotate, [Vect.by_value,Vect.by_value], Vect.by_value
  cp_static_inline :cpvunrotate, [Vect.by_value,Vect.by_value], Vect.by_value

  cp_static_inline :cpvlengthsq, [Vect.by_value], CP_FLOAT

  cp_static_inline :cpvlerp, [Vect.by_value,Vect.by_value], Vect.by_value

  cp_static_inline :cpvnormalize, [Vect.by_value], Vect.by_value
  cp_static_inline :cpvnormalize_safe, [Vect.by_value], Vect.by_value

  cp_static_inline :cpvclamp, [Vect.by_value,Vect.by_value], Vect.by_value
  cp_static_inline :cpvlerpconst, [Vect.by_value,Vect.by_value], Vect.by_value
  cp_static_inline :cpvdist, [Vect.by_value,Vect.by_value], CP_FLOAT
  cp_static_inline :cpvdistsq, [Vect.by_value,Vect.by_value], CP_FLOAT

  cp_static_inline :cpvnear, [Vect.by_value,Vect.by_value, CP_FLOAT], :int

  func :cpvlength, [Vect.by_value], CP_FLOAT
  func :cpvforangle, [CP_FLOAT], Vect.by_value
  func :cpvslerp, [Vect.by_value, Vect.by_value, CP_FLOAT], Vect.by_value
  func :cpvslerpconst, [Vect.by_value, Vect.by_value, CP_FLOAT], Vect.by_value
  func :cpvtoangle, [Vect.by_value], CP_FLOAT
  func :cpvstr, [Vect.by_value], :string

  class Vec2
    attr_accessor :struct
    def initialize(*args)
      case args.size
      when 1
        @struct = args.first
      when 2
        @struct = CP.cpv(*args)
      else
        raise "wrong number of args for Vec, got #{args.size}, but expected 2"
      end
    end

    def x
      @struct.x
    end
    def x=(new_x)
      raise TypeError "cant't modify frozen object" if frozen?
      @struct.x = new_x
    end
    def y
      @struct.y
    end
    def y=(new_y)
      raise TypeError "cant't modify frozen object" if frozen?
      @struct.y = new_y
    end

    def self.for_angle(angle)
      Vec2.new CP.cpvforangle(angle)
    end

    def to_s
      CP.cpvstr @struct
    end

    def to_angle
      CP.cpvtoangle @struct
    end

    def to_a
      [@struct.x,@struct.y]
    end

    def -@
      Vec2.new CP.cpvneg(@struct)  
    end

    def +(other_vec)
      Vec2.new CP.cpvadd(@struct, other_vec.struct)
    end

    def -(other_vec)
      Vec2.new CP.cpvsub(@struct, other_vec.struct)
    end

    def *(s)
      Vec2.new CP.cpvmult(@struct, s)
    end

    def /(s)
      factor = 1.0/s
      Vec2.new CP.cpvmult(@struct, factor)
    end

    def dot(other_vec)
      CP.cpvdot(@struct, other_vec.struct)
    end

    def cross(other_vec)
      CP.cpvcross(@struct, other_vec.struct)
    end

    def perp
      Vec2.new CP.cpvperp(@struct)
    end

    def rperp
      Vec2.new CP.cpvperp(@struct)
    end

    def project(other_vec)
      Vec2.new CP.cpvproject(@struct, other_vec.struct)
    end

    def rotate(other_vec)
      Vec2.new CP.cpvrotate(@struct, other_vec.struct)
    end

    def unrotate(other_vec)
      Vec2.new CP.cpvunrotate(@struct, other_vec.struct)
    end

    def lengthsq
      CP.cpvlengthsq(@struct)
    end

    def lerp(other_vec)
      Vec2.new CP.cpvlerp(@struct, other_vec.struct)
    end

    def normalize
      Vec2.new CP.cpvnormalize(@struct)
    end

    def normalize!
      @struct = CP.cpvnormalize(@struct)
      self
    end

    def normalize_safe
      Vec2.new CP.cpvnormalize_safe(@struct)
    end

    def clamp(other_vec)
      Vec2.new CP.cpvclamp(@struct)
    end

    def lerpconst(other_vec)
      Vec2.new CP.cpvlerpconst(@struct)
    end

    def dist(other_vec)
      CP.cpvdist(@struct)
    end

    def distsq(other_vec)
      CP.cpvdistsq(@struct)
    end

    def near?(other_vec, dist)
      delta_v = CP.cpvsub(@struct, other_vec.struct)
      CP.cpvdot(delta_v, delta_v) < dist*dist
    end

    def length
      CP::cpvlength @struct
    end

  end
  ZERO_VEC_2 = Vec2.new(0,0).freeze

end
def vec2(x,y)
  CP::Vec2.new x, y
end
