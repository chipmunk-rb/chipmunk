module CP

  class BBStruct < NiceFFI::Struct
    layout( :l, CP_FLOAT,
           :b, CP_FLOAT,
           :r, CP_FLOAT,
           :t, CP_FLOAT )
  end

  cp_static_inline :cpBBNew,  [CP_FLOAT,CP_FLOAT,CP_FLOAT,CP_FLOAT], BBStruct.by_value
  cp_static_inline :cpBBintersects, [BBStruct.by_value,BBStruct.by_value], :int
  cp_static_inline :cpBBcontainsBB, [BBStruct.by_value,BBStruct.by_value], :int
  cp_static_inline :cpBBcontainsVect, [BBStruct.by_value,Vect.by_value], :int
  cp_static_inline :cpBBClampVect, [BBStruct.by_value,Vect.by_value], Vect.by_value
  cp_static_inline :cpBBWrapVect, [BBStruct.by_value,Vect.by_value], Vect.by_value

  class BB
    attr_reader :struct
    def initialize(l,b,r,t)
      @struct = CP.cpBBNew(l,b,r,t)
    end
    def l;@struct.l;end
    def b;@struct.b;end
    def r;@struct.r;end
    def t;@struct.t;end

    def l=(new_l);@struct.l=new_l;end
    def b=(new_b);@struct.b=new_b;end
    def r=(new_r);@struct.r=new_r;end
    def t=(new_t);@struct.t=new_t;end

    def intersect?(other_bb)
      b = CP.cpBBintersects(@struct,other_bb.struct)
      b == 0 ? false : true
    end

    def contains_bb?(other_bb)
      b = CP.cpBBcontainsBB(@struct,other_bb.struct)
      b == 0 ? false : true
    end

    def contains_vect?(other_bb)
      b = CP.cpBBcontainsVect(@struct,other_bb.struct)
      b == 0 ? false : true
    end

    def clamp_vect(v)
      v_struct = CP.cpBBClampVect(@struct,v.struct)
      Vec2.new v_struct
    end

    def wrap_vect(v)
      v_struct = CP.cpBBWrapVect(@struct,v.struct)
      Vec2.new v_struct
    end

    def to_s
      "#<CP::BB:(% .3f, % .3f) -> (% .3f, % .3f)>" % [l,b,r,t]
    end
  end

end

