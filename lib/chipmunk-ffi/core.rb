module CP
  INFINITY = 1.0/0.0
  
  attach_variable :cpVersionString, :string
  def self.version
    cpVersionString
  end
  VERSION = version.freeze

  attach_variable :cp_bias_coef, CP_FLOAT
  def bias_coef
    cp_bias_coef
  end
  def bias_coef=(coef)
    cp_bias_coef = coef
  end

  attach_variable :cp_collision_slop, CP_FLOAT
  def collision_slop
    cp_collision_slop
  end
  def collision_slop=(slop)
    cp_collision_slop = slop
  end

  func :cpMomentForCircle, [CP_FLOAT,CP_FLOAT,CP_FLOAT,Vect.by_value], CP_FLOAT
  def self.moment_for_circle(m,r1,r2,offset)
    cpMomentForCircle(m, r1, r2, offset.struct);
  end

  func :cpMomentForSegment, [CP_FLOAT,Vect.by_value,Vect.by_value], CP_FLOAT
  def self.moment_for_segment(m,v1,v2)
    cpMomentForCircle(m, v1.struct, v2.struct)
  end

  func :cpMomentForPoly, [CP_FLOAT,:int,:pointer,Vect.by_value], CP_FLOAT
  def self.moment_for_poly(m,verts,offset)
    mem_pointer = FFI::MemoryPointer.new Vect, verts.size
    vert_structs = verts.collect{|s|s.struct}

    size = Vect.size
    tmp = mem_pointer
    vert_structs.each_with_index {|i, j|
      tmp.send(:put_bytes, 0, i.to_bytes, 0, size)
      tmp += size unless j == vert_structs.length-1 # avoid OOB
    }
    cpMomentForPoly(m, verts.size, mem_pointer, offset.struct)
  end

  def moment_for_circle(*args);CP.moment_for_circle(*args);end
  def moment_for_poly(*args);CP.moment_for_poly(*args);end
  def moment_for_segment(*args);CP.moment_for_segment(*args);end
  func :cpInitChipmunk, [], :void
  cpInitChipmunk

end
