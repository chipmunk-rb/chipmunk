require 'rubygems'
require 'nice-ffi'

module CP
  extend NiceFFI::Library


  unless defined? CP::LOAD_PATHS
    # Check if the application has defined CP_PATHS with some
    # paths to check first for chipmunk library.
    CP::LOAD_PATHS = if defined? ::CP_PATHS
                       NiceFFI::PathSet::DEFAULT.prepend( ::CP_PATHS )
                     else
                       NiceFFI::PathSet::DEFAULT
                     end

  end
  load_library "chipmunk", CP::LOAD_PATHS

  class Vect < NiceFFI::Struct
    layout( :x, :double,
           :y, :double )

  end

  class Vec2
    def initialize(x,y)
      @ptr = FFI::MemoryPointer.new CP::Vect
      @struct = Vect.new @ptr
      @struct.x = x
      @struct.y = y
    end

    def length()
      CP::cpvlength(@struct)
    end
  end
  ZERO_VEC_2 = Vec2.new(0,0).freeze

  func :cpvlength, [Vect.by_value], :double
end

p CP::Vec2.new(5,7).length
p CP::ZERO_VEC_2
p CP::ZERO_VEC_2.length

