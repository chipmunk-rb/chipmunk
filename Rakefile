require 'rake'
require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'

CHIPMUNK_VERSION = "6.1.3.3"
dlext = RbConfig::CONFIG['DLEXT']

CLEAN.include("ext/**/*.#{dlext}", "ext/**/.log", "ext/**/.o", "ext/**/*~", "ext/**/*#*", "ext/**/.obj", "ext/**/.def", "ext/**/.pdb")
CLOBBER.include("**/*.#{dlext}", "**/*~", "**/*#*", "**/*.log", "**/*.o", "doc/**")

