require 'mkmf'

RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

if ARGV.member?('--help') || ARGV.member?('-?') 
  puts "ruby extconf.rb:"
  puts "Options for the Ruby bindings to Chipmunk: "
  puts "--disable-vendor    Disables vendoring Chipmunk."
  puts "--enable-vendor     Enables vendoring Chipmunk."
  puts "--enable-macosx     Enables compiling for OS-X."
  puts "--enable-64         Enables compiling to 64 bits targets."
  puts
  exit
end

p "pwd", Dir.pwd

dir_config('chipmunk')

VENDORED_CHIPMUNK     = 'chipmunk-5.3.4'
VENDORED_SRC_DIR      =  File.join($srcdir, 'vendor', VENDORED_CHIPMUNK, 'src')
VENDORED_SRC_DIR2     =  File.join($srcdir, 'vendor', VENDORED_CHIPMUNK, 'src',
                                   'constraints')
VENDORED_INCLUDE_DIR  =  File.join($srcdir, 'vendor', VENDORED_CHIPMUNK, 'include',
                                   'chipmunk')


MINGW = '/usr/i586-mingw32msvc'
CHIPMUNK_HEADER   = 'chipmunk.h'
CHIPMUNK_NAME     = 'chipmunk'
CHIPMUNK_FUNCTION = 'cpMomentForPoly'
CHIPMUNK_INCLUDE  = [ '/usr/include', 
                      File.join(MINGW, 'include'),
                      File.join(MINGW, 'include', 'chipmunk'),
                     '/usr/local/include', 
                     '/usr/include/chipmunk',
                     '/usr/local/include/chipmunk'
                    ]
CHIPMUNK_LIBDIR   = ['/usr/lib', File.join(MINGW, 'lib'), '/usr/local/lib']

# This is a bit of a trick to cleanly vendor the chipmunk C library.
sources           = Dir.glob(File.join($srcdir, 'rb_*.c')).to_a
# normally, we need the rb_xxx files...


if enable_config("vendor", true)
  unless find_header(CHIPMUNK_HEADER, VENDORED_INCLUDE_DIR)
    raise "Vendored chipmunk #{VENDORED_INCLUDE_DIR} not found!"
  end
  CHIPMUNK_INCLUDE .unshift(VENDORED_INCLUDE_DIR)
  sources        += Dir.glob(File.join(VENDORED_SRC_DIR, '*.c'))
  sources        += Dir.glob(File.join(VENDORED_SRC_DIR2, '*.c'))
  # when vendoring, also include the needed c files files...
  
  
else
  unless find_header(CHIPMUNK_HEADER, *CHIPMUNK_INCLUDE)
    raise "Could not find Chipmunk headers!" 
  end

  unless find_library(CHIPMUNK_NAME, CHIPMUNK_FUNCTION, *CHIPMUNK_LIBDIR)
    raise "Could not link to Chipmunk library!" 
  end
end

# this is the core of the trick, it overrides create_makefile's looking for 
# based on the c files
$objs = sources.map { |s| s.gsub(/.c\Z/,'.o') }


=begin
have_header('chipmunk.h', include_dirs)
=end
if enable_config("macosx", false) 
    $CFLAGS += ' -arch ppc -arch i386 -arch x86_64'
    $LDFLAGS += ' -arch x86_64 -arch i386 -arch ppc'
end

if enable_config("64", false)
  $CFLAGS += ' -m64'
end
 
$CFLAGS += ' -std=gnu99 -ffast-math -DNDEBUG '
create_makefile('chipmunk')

