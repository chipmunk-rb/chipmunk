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
  def self.cp_static_inline(func_sym, ret, args)
    func_name = "_#{func_sym}"
    attach_variable func_name, :pointer
    const_func_name = func_sym.to_s.upcase

    func = FFI::Function.new(ret, args, FFI::Pointer.new(self.send(func_name)), :convention => :default )
    const_set const_func_name, func

    instance_eval <<-METHOD
    def #{func_sym}(*args)
      const_get('#{const_func_name}').call *args
    end
    METHOD
  end

  CP_FLOAT = :double

end
libs = %w{vec2 core bb}
libs.each do |lib|
  require "chipmunk-ffi/#{lib}"
end
