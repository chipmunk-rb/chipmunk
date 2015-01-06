require 'mkmf'
$CFLAGS += ' -std=c99 -ffast-math -DNDEBUG '
create_makefile('chipmunk/chipmunk')

