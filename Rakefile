# Rakefile added by John Mair (banisterfiend)

require 'rake'
require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'

begin
    require 'rake/extensiontask'
rescue LoadError
    puts "rake-compiler not found! Please install the rake-compiler gem!"
end

CHIPMUNK_VERSION = "6.1.3.2"
dlext = RbConfig::CONFIG['DLEXT']

CLEAN.include("ext/**/*.#{dlext}", "ext/**/.log", "ext/**/.o", "ext/**/*~", "ext/**/*#*", "ext/**/.obj", "ext/**/.def", "ext/**/.pdb")
CLOBBER.include("**/*.#{dlext}", "**/*~", "**/*#*", "**/*.log", "**/*.o", "doc/**")


def apply_gemspec_defaults(s)
    s.name = "chipmunk"
    s.summary = "Enhanced ruby bindings for the chipmunk 5.3.4 game physics engine."
    s.description = s.summary + " "
    s.version = CHIPMUNK_VERSION
    s.author = "Scott Lembcke, Beoran, John Mair (banisterfiend), Shawn Anderson"
    s.email = 'beoran@rubyforge.org'
    s.date = Time.now.strftime '%Y-%m-%d'
    s.require_path = 'lib'
    s.homepage = "https://github.com/beoran/chipmunk"
    s.license = 'MIT'
end

FILES = ["Rakefile", "README", "LICENSE", "lib/chipmunk.rb", "spec/*.rb"]

# common tasks
task :compile => :clean

# platform dependent tasks
# if RUBY_PLATFORM =~ /darwin/
# 
#     spec = Gem::Specification.new do |s|
#         apply_gemspec_defaults(s)
#         s.platform = Gem::Platform::CURRENT
#         s.files = ["Rakefile", "README", "LICENSE", "lib/chipmunk.rb", "lib/1.8/chipmunk.#{dlext}", "lib/1.9/chipmunk.#{dlext}"] +
#             FileList["ext/**/extconf.rb", "ext/**/*.h", "ext/**/*.c"].to_a
#     end
# 
#     Rake::ExtensionTask.new('chipmunk') do |ext|
#         ext.ext_dir   = "ext/chipmunk"
#         ext.lib_dir   = "lib/#{RUBY_VERSION[0..2]}"
#         ext.config_script = 'extconf.rb'
#         ext.config_options << '--enable-macosx'
#     end
# else

    spec = Gem::Specification.new do |s|
        apply_gemspec_defaults(s)
        s.platform = Gem::Platform::RUBY
        s.extensions = FileList["ext/**/extconf.rb"]
        s.files = ["Rakefile", "README", "LICENSE", "lib/chipmunk.rb"] +
            FileList["ext/**/extconf.rb", "ext/**/*.h", "ext/**/*.c"].to_a
    end

    Rake::ExtensionTask.new('chipmunk', spec) do |ext|
      ext.config_script = 'extconf.rb'
      ext.cross_compile = true
      ext.cross_platform = 'i586-mingw32'
        # ext.cross_platform = 'i386-mswin32'
    end

# end

namespace :win do
	 WINDOWS_SPEC = Gem::Specification.new do |s|
		apply_gemspec_defaults(s)
		s.platform = 'i386-mingw32'
        s.files = ["Rakefile", "README", "LICENSE", "lib/chipmunk.rb"] +
			FileList["lib/**/*.so"]
	end
	Gem::PackageTask.new(WINDOWS_SPEC) do |t|
		t.need_zip = false
		t.need_tar = false
	end
 end
 
namespace :mac do
	 MAC_SPEC = Gem::Specification.new do |s|
		apply_gemspec_defaults(s)
		s.platform = 'universal-darwin'
        s.files = ["Rakefile", "README", "LICENSE", "lib/chipmunk.rb"] +
			FileList["ext/**/*.h", "ext/**/*.c", "ext/chipmunk/extconf.rb"]
		s.extensions = ["ext/chipmunk/extconf.rb"]
	end
	Gem::PackageTask.new(MAC_SPEC) do |t|
		t.need_zip = false
		t.need_tar = false
	end
 end
 
namespace :linux do
	 LINUX_SPEC = Gem::Specification.new do |s|
		apply_gemspec_defaults(s)
		s.platform = 'ruby'
        s.files = ["Rakefile", "README", "LICENSE", "lib/chipmunk.rb"] +
			FileList["ext/**/*.h", "ext/**/*.c", "ext/chipmunk/extconf.rb"]
		s.extensions = ["ext/chipmunk/extconf.rb"]
		s.require_path = 'lib'
	end
  
	Gem::PackageTask.new(LINUX_SPEC) do |t|
		t.need_zip = false
		t.need_tar = false 
	end
end

# task :release => [:'win:gem', :'mac:gem', :'linux:gem']
task :release => [:'mac:gem', :'linux:gem']


