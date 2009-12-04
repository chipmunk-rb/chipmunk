module CP

  ShapeType = enum(
    :circle_shape,
    :segment_shape,
    :poly_shape,
    :num_shapes
  )

  callback :cacheData, [:pointer,Vect.by_value,Vect.by_value], BBStruct.by_value
  callback :destroy, [:pointer], :void
  callback :pointQuery, [:pointer,Vect.by_value], :int
  callback :segmentQuery, [:pointer,Vect.by_value,Vect.by_value,:pointer], :void

  class ShapeClassStruct < NiceFFI::Struct
    layout( :type, ShapeType,
           :cacheData, :pointer,
           :pointQuery, :pointer,
           :segmentQuery, :pointer
          )
  end

  class ShapeStruct < NiceFFI::Struct
    layout( :klass, :pointer,
           :body, :pointer,
           :bb, :pointer,
           :sensor, :int,
           :e, CP_FLOAT,
           :u, CP_FLOAT,
           :surface_v, Vect.by_value,
           :data, :pointer,
           :collision_type, :uint,
           :group, :uint,
           :layers, :size_t
          )
  end
  class SegmentQueryInfoStruct < NiceFFI::Struct
    layout(:shape, ShapeStruct,
           :t, CP_FLOAT,
           :n, Vect
          )
  end

  func :cpCircleShapeNew, [BodyStruct,CP_FLOAT,Vect.by_value], ShapeStruct
  func :cpSegmentShapeNew, [BodyStruct,Vect.by_value,Vect.by_value,CP_FLOAT], ShapeStruct
  func :cpPolyShapeNew, [BodyStruct,:int,:pointer,Vect.by_value], ShapeStruct
  func :cpShapeCacheBB, [ShapeStruct], :void

  module Shape
    attr_reader :struct

    def body
      Body.new BodyStruct.new(@struct.body)
    end
    def body=(new_body)
      @struct.body = new_body.struct.pointer
      new_body
    end

    def collision_type
      @collType
    end
    def collision_type=(col_type)
      @collType = col_type
      @struct.collision_type = col_type.object_id
    end

    def group
      @group
    end
    def group=(group_obj)
      @group = group_obj
      @struct.group = group_obj.object_id
    end

    def layers
      @struct.layers
    end
    def layers=(l)
      @struct.layers = l
    end

    def bb
      our_bb = @struct.bb
      if our_bb.null?
        nil
      else
        size = BBStruct.size
        bb_ptr = FFI::MemoryPointer.new size
        bb_ptr.send(:put_bytes, 0, our_bb.get_bytes(0, size), 0, size)
        BB.new(BBStruct.new(bb_ptr))
      end

    end

    def cache_bb
      CP.cpShapeCacheBB(@struct.bb)
      bb
    end

    def e
    end
    def e(new_e)
    end

    def u
    end
    def u=(new_u)
    end

    def surface_v
    end
    def surface_v=(new_sv)
    end

    def self.reset_id_counter
    end

    class Circle
      include Shape
      def initialize(body, rad, offset_vec)
        ptr = CP.cpCircleShapeNew body.struct.pointer, rad, offset_vec.struct
        @struct = ShapeStruct.new ptr
      end
    end
    class Segment
      include Shape
      def initialize(body, v1, v2, r)
        ptr = CP.cpSegmentShapeNew body.struct.pointer, v1.struct, v2.struct, r
        @struct = ShapeStruct.new ptr
      end
    end
    class Poly
      include Shape
      def initialize(body, verts, offset_vec)
        mem_pointer = FFI::MemoryPointer.new Vect, verts.size
        vert_structs = verts.collect{|s|s.struct}

        size = Vect.size
        tmp = mem_pointer
        vert_structs.each_with_index {|i, j|
          tmp.send(:put_bytes, 0, i.to_bytes, 0, size)
          tmp += size unless j == vert_structs.length-1 # avoid OOB
        }
        ptr = CP.cpPolyShapeNew body.struct.pointer, verts.size, mem_pointer, offset_vec.struct
        @struct = ShapeStruct.new ptr
      end
    end
  end


end
