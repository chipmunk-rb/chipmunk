require 'mkmf'

if ARGV[0]  == "macosx"
    $CFLAGS += ' -arch ppc -arch i386'
    $LDFLAGS += ' -arch i386 -arch ppc'
end

$CFLAGS += ' -std=gnu99 -ffast-math'
create_makefile('chipmunk')
