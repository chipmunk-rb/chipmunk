require 'chipmunk-ffi'

module CP
  func :cpCircleShapeSetRadius, [:pointer, CP_FLOAT], :void
  func :cpCircleShapeSetOffset, [:pointer, Vect.by_value], :void
  
  func :cpSegmentShapeSetEndpoints, [:pointer, Vect.by_value, Vect.by_value], :void
  func :cpSegmentShapeSetRadius,    [:pointer, CP_FLOAT], :void
  
  func :cpPolyShapeSetVerts, [:pointer, :int, :pointer, Vect.by_value], :void
  
  module Shape
    class Circle
      def radius=(new_radius)
        CP.cpCircleShapeSetRadius(@struct, new_radius)
      end
      def offset=(new_offset)
        CP.cpCircleShapeSetOffset(@struct, new_offset.struct)
      end
    end
    class Segment
      def endpoints=(new_endpoints)
        new_a, new_b = *new_endpoints.map { |v| v.struct }
        CP.cpSegmentShapeSetEndpoints(@struct, new_a, new_b)
      end
      def radius=(new_radius)
        CP.cpSegmentShapeSetRadius(@struct, new_radius)
      end
    end
    class Poly
      def verts=(new_verts_and_offset)
        new_verts, new_offset = *new_verts_and_offset
        
        new_verts_pointer = FFI::MemoryPointer.new Vect, new_verts.count
        
        size = Vect.size
        tmp = new_verts_pointer
        new_verts.each_with_index  do |vert, i|
          tmp.send(:put_bytes, 0, vert.struct.to_bytes, 0, size)
          tmp += size unless i == new_verts.length - 1 # avoid OOB
        end
        
        CP.cpPolyShapeSetVerts(@struct.pointer, new_verts.count, new_verts_pointer, new_offset.struct)
      end
    end
  end
end
