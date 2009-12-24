module CP

  callback :cpSpaceHashBBFunc, [:pointer], BBStruct.by_value

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

  class SpaceHash
    attr_reader :struct
    def initialize(cell_dim, cells, &bb_func)
      raise "need bb func" unless block_given?
      @struct = SpaceHashStruct.new(CP.cpSpaceHashNew(cell_dim, cells, bb_func))
    end

    def num_cells;@struct.num_cells;end
    def cell_dim;@struct.cell_dim;end

  end

end


