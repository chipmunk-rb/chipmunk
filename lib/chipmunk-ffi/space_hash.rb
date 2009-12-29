module CP

  callback :cpSpaceHashBBFunc, [:pointer], BBStruct.by_value
  callback :cpSpaceHashQueryFunc, [:pointer, :pointer, :pointer], :void

  class SpaceHashStruct < NiceFFI::Struct
    layout(:num_cells, :int,
           :cell_dim, CP_FLOAT,
           :bb_func, :cpSpaceHashBBFunc,
           :handle_set, :pointer,
           :table, :pointer,
           :bins, :pointer,
           :stamp, :int)
  end
  func :cpSpaceHashNew,  [CP_FLOAT,:int,:cpSpaceHashBBFunc], :pointer
  func :cpSpaceHashQuery, [:pointer, :pointer, BBStruct.by_value, :cpSpaceHashQueryFunc, :pointer], :void
  func :cpSpaceHashInsert, [:pointer, :pointer, :uint, BBStruct.by_value], :void
  func :cpSpaceHashRemove, [:pointer, :pointer, :uint], :void

  class SpaceHash
    attr_reader :struct
    def initialize(*args, &bb_func)
      case args.size
      when 1
        @struct = args.first
      when 2
        raise "need bb func" unless block_given?
        cell_dim = args[0]
        cells = args[1]
        @struct = SpaceHashStruct.new(CP.cpSpaceHashNew(cell_dim, cells, bb_func))
      end
    end

    def num_cells;@struct.num_cells;end
    def cell_dim;@struct.cell_dim;end
    
    def insert(obj, bb)
      CP.cpSpaceHashInsert(@struct.pointer, obj.struct.pointer, obj.struct.hash_value, bb.struct)
    end

    def remove(obj)
      CP.cpSpaceHashRemove(@struct.pointer, obj.struct.pointer, obj.struct.hash_value)
    end

    def query_func
      @query_func ||= Proc.new do |obj,other,data|
        s = ShapeStruct.new(other)
        obj_id = s.data.get_long 0
        @shapes <<  ObjectSpace._id2ref(obj_id)
      end
    end

    def query_by_bb(bb)
      @shapes = []
      CP.cpSpaceHashQuery(@struct.pointer, nil, bb.struct, query_func, nil)
      @shapes
    end

  end

end


