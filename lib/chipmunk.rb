# this redirection script by John Mair (banisterfiend)

require 'rbconfig'

direc = File.dirname(__FILE__)
dlext = Config::CONFIG['DLEXT']
begin
    if RUBY_VERSION && RUBY_VERSION =~ /1.9/
        require "#{direc}/1.9/chipmunk.#{dlext}"
    else
        require "#{direc}/1.8/chipmunk.#{dlext}"
    end
rescue LoadError => e
    require "#{direc}/chipmunk.#{dlext}"
end

# Add some constants to CP here, so we don't need 
# to do it in the C code.
# Let's cheat a bit here.. :p

module CP
  ZERO_VEC_2 = Vec2.new(0,0).freeze
  ALL_ONES   = Vec2.new(1,1).freeze
end  
 



