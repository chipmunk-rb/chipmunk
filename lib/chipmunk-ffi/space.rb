module CP
  callback :cpCollisionBeginFunc, [:pointer,:pointer,:pointer], :int
  callback :cpCollisionPreSolveFunc, [:pointer,:pointer,:pointer], :int
  callback :cpCollisionPostSolveFunc, [:pointer,:pointer,:pointer], :int
  callback :cpCollisionSeparateFunc, [:pointer,:pointer,:pointer], :int

  class CollisionHandlerStruct < NiceFFI::Struct
    layout(
      :a, :uint,
      :b, :uint,
      :begin, :cpCollisionBeginFunc,
      :pre_solve, :cpCollisionPreSolveFunc,
      :post_solve, :cpCollisionPostSolveFunc,
      :separate, :cpCollisionSeparateFunc,
      :data, :pointer
    )
  end

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

  class SpaceStruct < NiceFFI::Struct
    layout( :iterations, :int,
      :elastic_iterations, :int,
      :gravity, Vect.by_value,
      :damping, CP_FLOAT,
      :stamp, :int,
      :static_shapes, :pointer,
      :active_shapes, :pointer,
      :bodies, :pointer,
      :arbiters, :pointer,
      :contact_set, :pointer,
      :constraints, :pointer,
      :coll_func_set, :pointer,
      :default_handler, CollisionHandlerStruct.by_value,
      :post_step_callbacks, :pointer
    )
    def self.release(ptr)
      CP.cpSpaceFreeChildren(ptr)
    end
  end


  func :cpSpaceNew, [], :pointer
  func :cpSpaceFreeChildren, [:pointer], :void
  
  func :cpSpaceAddShape, [:pointer, :pointer], :pointer
  func :cpSpaceAddStaticShape, [:pointer, :pointer], :pointer
  func :cpSpaceAddBody, [:pointer, :pointer], :pointer
  func :cpSpaceAddConstraint, [:pointer, :pointer], :pointer

  func :cpSpaceRemoveShape, [:pointer, :pointer], :void
  func :cpSpaceRemoveStaticShape, [:pointer, :pointer], :void
  func :cpSpaceRemoveBody, [:pointer, :pointer], :void
  func :cpSpaceRemoveConstraint, [:pointer, :pointer], :void

  func :cpSpaceRehashStatic, [:pointer], :void
  func :cpSpaceStep, [:pointer,:double], :void
  func :cpSpaceResizeActiveHash, [:pointer,CP_FLOAT,:int], :void
  func :cpSpaceResizeStaticHash, [:pointer,CP_FLOAT,:int], :void


  func :cpSpaceSetDefaultCollisionHandler, [:pointer, :uint, :uint,
   :pointer, :pointer, :pointer, :pointer, :pointer], :void
  func :cpSpaceAddCollisionHandler, [:pointer, :uint, :uint,
   :cpCollisionBeginFunc, :cpCollisionPreSolveFunc, :cpCollisionPostSolveFunc, :cpCollisionSeparateFunc, :pointer], :void
  func :cpSpaceRemoveCollisionHandler, [:pointer, :uint, :uint], :void
  class Space
    attr_reader :struct
    def initialize
      @struct = SpaceStruct.new(CP.cpSpaceNew)
      @static_shapes = []
      @active_shapes = []
      @bodies = []
      @constraints = []
      @blocks = {}
    end
    
    def iterations
      @struct.iterations
    end
    def iterations=(its)
      @struct.iterations = its
    end

    def elastic_iterations
      @struct.elastic_iterations
    end
    def elastic_iterations=(elastic_its)
      @struct.elastic_iterations = elastic_its
    end

    def damping
      @struct.damping
    end
    def damping=(damp)
      @struct.damping = damp
    end

    def gravity
      Vec2.new @struct.gravity
    end
    def gravity=(v)
      @struct.gravity.pointer.put_bytes 0, v.struct.to_bytes, 0,Vect.size
    end

    def add_collision_func(a,b,&block)
      beg = Proc.new do |arb_ptr,space_ptr,data_ptr|
        begin
          arb = ArbiterStruct.new(arb_ptr)

          swapped = arb.swapped_col == 0 ? false : true
          arba = swapped ? arb.b : arb.a
          arbb = swapped ? arb.a : arb.b

          as = ShapeStruct.new(arba)
          a_obj_id = as.data.get_ulong 0
          rb_a = ObjectSpace._id2ref a_obj_id

          bs = ShapeStruct.new(arbb)
          b_obj_id = bs.data.get_ulong 0
          rb_b = ObjectSpace._id2ref b_obj_id

          block.call rb_a, rb_b
#          1 #always return true for now
          0
        rescue Exception => ex
          puts ex.message
          puts ex.backtrace
          0
        end
      end
      #making sure GC is't messin w/ me..
      $saved_procs ||= []
      $saved_blocks ||= []
      $saved_procs << beg
      $saved_blocks << block
      pre = nil
      post = nil
      sep = nil
      data = nil
      a_id = a.object_id
      b_id = b.object_id
      CP.cpSpaceAddCollisionHandler(@struct.pointer, a_id, b_id,
          beg,pre,post,sep,data)
      @blocks[[a_id,b_id]] = block
      nil
    end

    def remove_collision_func(a,b)
      a_id = a.object_id
      b_id = b.object_id
#      CP.cpSpaceRemoveCollisionHandler(@struct.pointer, a_id, b_id)
      @blocks.delete [a_id,b_id]
      nil
    end

    def set_default_collision_func(&block)
      @blocks[:default] = block 
    end

    def add_shape(shape)
      CP.cpSpaceAddShape(@struct.pointer, shape.struct.pointer)
      @active_shapes << shape
      shape
    end

    def add_static_shape(shape)
      CP.cpSpaceAddStaticShape(@struct.pointer, shape.struct.pointer)
      @static_shapes << shape
      shape
    end

    def add_body(body)
      CP.cpSpaceAddBody(@struct.pointer, body.struct.pointer)
      @bodies << body
      body
    end

    def add_constraint(con)
      CP.cpSpaceAddConstraint(@struct.pointer, con.struct.pointer)
      @constraints << con
      con
    end

    def remove_shape(shape)
      puts "FFI removing shape: #{shape.object_id} #{shape.struct.data.get_ulong(0)}"
      CP.cpSpaceRemoveShape(@struct.pointer, shape.struct.pointer)
      @active_shapes.delete shape
      shape
    end

    def remove_static_shape(shape)
      CP.cpSpaceRemoveStaticShape(@struct.pointer, shape.struct.pointer)
      @static_shapes.delete shape
      shape
    end

    def remove_body(body)
      CP.cpSpaceRemoveBody(@struct.pointer, body.struct.pointer)
      @bodies.delete body
      body
    end

    def remove_constraint(con)
      CP.cpSpaceRemoveConstraint(@struct.pointer, con.struct.pointer)
      @constraints.delete con
      con
    end

    def resize_static_hash(dim, count)
      CP.cpSpaceResizeStaticHash @struct.pointer, dim, count
    end

    def resize_active_hash(dim, count)
      CP.cpSpaceResizeActiveHash @struct.pointer, dim, count
    end

    def rehash_static
      CP.cpSpaceRehashStatic @struct.pointer
    end

    def step(dt)
      @step ||= 0
      @step += 1
      puts "================= STEP #{@step} =================="
      @active_shapes.each do |shape|
        puts "AS: #{shape.object_id} #{shape.struct.data.get_ulong(0)}"
        raise "CORRUPT" unless shape.object_id == shape.struct.data.get_ulong(0)
      end
      CP.cpSpaceStep @struct.pointer, dt
    end

    def shape_point_query(*args)
      raise "Not Implmented yet"
    end

    def static_shape_point_query(*args)
      raise "Not Implmented yet"
    end

    def each_body(&block)
      @bodies.each &block
#      typedef void (*cpSpaceBodyIterator)(cpBody *body, void *data);
#      void cpSpaceEachBody(cpSpace *space, cpSpaceBodyIterator func, void *data);
    end


  end
end

