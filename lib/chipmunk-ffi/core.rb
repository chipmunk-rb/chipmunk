module CP
  INFINITY = 1.0/0.0

  attach_variable :cp_bias_coef, CP_FLOAT
  def self.bias_coef
    cp_bias_coef
  end
  def self.bias_coef=(coef)
    cp_bias_coef = coef
  end

  attach_variable :cp_collision_slop, CP_FLOAT
  def self.collision_slop
    cp_collision_slop
  end
  def self.collision_slop=(slop)
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
  def self.moment_for_poly(m,numVerts,verts,offset)
    cpMomentForPoly(m, numVerts, verts.struct, offset.struct)
  end
end
