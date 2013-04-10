require 'mkmf'

RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

if ARGV.member?('--help') || ARGV.member?('-?')
  puts "ruby extconf.rb:"
  puts "Options for the Ruby bindings to Chipmunk: "
  puts "--enable-macosx     Enables compiling for OS-X."
  puts "--enable-64         Enables compiling to 64 bits targets."
  puts
  exit
end

dir_config('chipmunk')
have_header('chipmunk.h')

if enable_config("macosx", false)
    # $CFLAGS += ' -arch ppc -arch i386 -arch x86_64'
    # $LDFLAGS += ' -arch x86_64 -arch i386 -arch ppc'
    $CFLAGS += ' -arch x86_64'
    $LDFLAGS += ' -arch x86_64'
end

if enable_config("64", false)
  $CFLAGS += ' -m64'
end

$CFLAGS += ' -std=gnu99 -ffast-math -DNDEBUG '
create_makefile('chipmunk')

