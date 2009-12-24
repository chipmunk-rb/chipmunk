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
           :destroy, :pointer,
           :pointQuery, :pointer,
           :segmentQuery, :pointer
          )
  end

  class ShapeStruct < NiceFFI::Struct
    layout( :klass, :pointer,
           :body, :pointer,
           :bb, BBStruct.by_value,
           :sensor, :int,
           :e, CP_FLOAT,
           :u, CP_FLOAT,
           :surface_v, Vect.by_value,
           :data, :pointer,
           :collision_type, :uint,
           :group, :uint,
           :layers, :uint,
           :hash_value, :size_t
          )
  end
  class SegmentQueryInfoStruct < NiceFFI::Struct
    layout(:shape, :pointer,
           :t, CP_FLOAT,
           :n, Vect
          )
  end


  func :cpCircleShapeNew, [BodyStruct,CP_FLOAT,Vect.by_value], ShapeStruct
  func :cpSegmentShapeNew, [BodyStruct,Vect.by_value,Vect.by_value,CP_FLOAT], ShapeStruct
  func :cpPolyShapeNew, [BodyStruct,:int,:pointer,Vect.by_value], ShapeStruct
  func :cpShapeCacheBB, [ShapeStruct], :void
  func :cpResetShapeIdCounter, [], :void
  func :cpShapePointQuery, [:pointer, Vect.by_value], :int
	func :cpShapeSegmentQuery, [:pointer, Vect.by_value, Vect.by_value, :pointer], :int

  module Shape
    class SegmentQueryInfo
      attr_reader :hit, :t, :n
			def initialize(hit,t=nil,n=nil,info=nil,ptr=nil)
				@hit = hit
				@t = t
				@n = n
				@info = info
				@ptr = ptr
      end
    end

    attr_reader :struct

    def body
      @body
    end
    def body=(new_body)
      @struct.body = new_body.struct.pointer
      @body = new_body
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
      size = BBStruct.size
      bb_ptr = FFI::MemoryPointer.new size
      bb_ptr.send(:put_bytes, 0, our_bb.to_bytes, 0, size)
      BB.new(BBStruct.new(bb_ptr))
    end

    def cache_bb
      CP.cpShapeCacheBB(@struct.bb) 
      bb
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

    def data
      @struct.data
    end
    def data=(new_data)
      @struct.data = new_data
    end

    def surface_v
      Vec2.new @struct.surface_v
    end 
    def surface_v=(new_sv)
      @struct.surface_v.pointer.put_bytes 0, new_sv.struct.to_bytes, 0,Vect.size
    end

    def point_query(point)
      bool_int = CP.cpShapePointQuery(@struct.pointer, point.struct)
      bool_int == 0 ? false : true
    end

    def set_data_pointer
      mem = FFI::MemoryPointer.new(:long)
      mem.put_long 0, object_id
      # this is needed to prevent data corruption by GC
      @shape_pointer = mem
      @struct.data = mem
    end

    def self.reset_id_counter
      CP.cpResetShapeIdCounter
    end

		def segment_query(a,b)
			ptr = FFI::MemoryPointer.new(SegmentQueryInfoStruct.size)
			info = SegmentQueryInfoStruct.new ptr
	
      bool_int = CP.cpShapeSegmentQuery(@struct.pointer, a.struct,b.struct,ptr)
      hit = bool_int == 0 ? false : true
			if hit
        #obj_id = info.shape.data.get_long 0
        #shape = ObjectSpace._id2ref obj_id
				# TODO prob need to dup these things
				n = Vec2.new(Vect.new(info.n))
				SegmentQueryInfo.new hit, info.t, n, info, ptr
			else
				SegmentQueryInfo.new hit
			end
		end
    class Circle
      include Shape
      def initialize(body, rad, offset_vec)
        @body = body
        ptr = CP.cpCircleShapeNew body.struct.pointer, rad, offset_vec.struct
        @struct = ShapeStruct.new ptr
        set_data_pointer
      end
    end
    class Segment
      include Shape
      def initialize(body, v1, v2, r)
        @body = body
        ptr = CP.cpSegmentShapeNew body.struct.pointer, v1.struct, v2.struct, r
        @struct = ShapeStruct.new ptr
        set_data_pointer
      end
    end
    class Poly
      include Shape
      def initialize(body, verts, offset_vec)
        @body = body
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
        set_data_pointer
      end
    end
  end


end
