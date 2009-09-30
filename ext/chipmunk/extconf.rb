require 'mkmf'

$CFLAGS += ' -std=gnu99 -ffast-math'
create_makefile('chipmunk')
