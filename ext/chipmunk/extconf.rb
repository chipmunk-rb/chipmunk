require 'mkmf'
dir_config('chipmunk')

CHIPMUNK_HEADER   = 'chipmunk.h'
CHIPMUNK_NAME     = 'chipmunk'
CHIPMUNK_FUNCTION = 'cpMomentForPoly'
CHIPMUNK_INCLUDE  = ['/usr/include', 
                     '/usr/local/include', 
                     '/usr/include/chipmunk',
                     '/usr/local/include/chipmunk'
                    ]
CHIPMUNK_LIBDIR   = ['/usr/lib', '/usr/local/lib']

find_header(CHIPMUNK_HEADER, *CHIPMUNK_INCLUDE)
find_library(CHIPMUNK_NAME, CHIPMUNK_FUNCTION, *CHIPMUNK_LIBDIR)

=begin
unless have_library('chipmunk', 'cpMomentForPoly')
  raise "Could not link to Chipmunk library!" 
end

have_header('chipmunk.h', include_dirs)
=end
 
if ARGV[0] == "macosx"
    $CFLAGS += ' -arch ppc -arch i386 -arch x86_64'
    $LDFLAGS += ' -arch x86_64 -arch i386 -arch ppc'
end
 
$CFLAGS += ' -std=gnu99 -ffast-math'
create_makefile('chipmunk')

