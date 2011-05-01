require 'mkmf'

RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

dir_config('chipmunk')

MINGW = '/usr/i586-mingw32msvc'
CHIPMUNK_HEADER   = 'chipmunk.h'
CHIPMUNK_NAME     = 'chipmunk'
CHIPMUNK_FUNCTION = 'cpMomentForPoly'
CHIPMUNK_INCLUDE  = ['/usr/include', 
                      File.join(MINGW, 'include'),
                      File.join(MINGW, 'include', 'chipmunk'),
                     '/usr/local/include', 
                     '/usr/include/chipmunk',
                     '/usr/local/include/chipmunk'
                    ]
CHIPMUNK_LIBDIR   = ['/usr/lib', 
File.join(MINGW, 'lib'),
'/usr/local/lib']

unless find_header(CHIPMUNK_HEADER, *CHIPMUNK_INCLUDE)
  raise "Could not find Chipmunk headers!" 
end


unless find_library(CHIPMUNK_NAME, CHIPMUNK_FUNCTION, *CHIPMUNK_LIBDIR)
  raise "Could not link to Chipmunk library!" 
end

=begin
have_header('chipmunk.h', include_dirs)
=end
 
if ARGV[0] == "macosx"
    $CFLAGS += ' -arch ppc -arch i386 -arch x86_64'
    $LDFLAGS += ' -arch x86_64 -arch i386 -arch ppc'
end
 
$CFLAGS += ' -std=gnu99 -ffast-math'
create_makefile('chipmunk')

