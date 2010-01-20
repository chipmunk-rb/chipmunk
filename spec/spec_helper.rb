require 'spec'
$: << File.dirname(__FILE__)+'/../lib'



require 'chipmunk'

# Let's cheat a bit here.. :p
module CP
  ZERO_VEC_2 = Vec2.new(0,0).freeze
end  


# require 'chipmunk/unsafe'
include CP
