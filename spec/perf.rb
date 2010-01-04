# test for performance vs old ruby bindings
require 'rubygems'
require 'benchmark'

n = 100000
#require 'chipmunk-ffi'
#n.times do
#  vec2(4,3)
#end
#exit

Benchmark.bm do |x|
  require 'chipmunk'
  x.report("cp vec2    ") {
    n.times do
      vec2(4,3)
    end
  }
  x.report("cp vec2 sub") {
    n.times do
      vec2(4,3)-vec2(5,6)
    end
  }
  require 'chipmunk-ffi'
  x.report("cp-ffi vec2") {
    n.times do
      vec2(4,3)
    end
  }
  x.report("cp vec2 ffi sub") {
    n.times do
      vec2(4,3)-vec2(5,6)
    end
  }
end

