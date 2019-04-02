require 'rubygems'
require 'rubygems/package_task'
require 'rake'
require 'rake/clean'
require 'pry'

CHIPMUNK_VERSION = "6.1.3.3"
dlext = RbConfig::CONFIG['DLEXT']

CLEAN.include("ext/**/*.#{dlext}", "ext/**/.log", "ext/**/.o", "ext/**/*~", "ext/**/*#*", "ext/**/.obj", "ext/**/.def", "ext/**/.pdb")
CLOBBER.include("**/*.#{dlext}", "**/*~", "**/*#*", "**/*.log", "**/*.o", "doc/**")

require 'mkmf'
require 'rake/extensiontask'
Rake::ExtensionTask.new('chipmunk')

