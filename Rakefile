# Rakefile added by John Mair (banisterfiend)

require 'rake/clean'
require 'rake/extensiontask'
require 'rake/gempackagetask'

CHIPMUNK_VERSION = "4.1.0"

dlext = Config::CONFIG['DLEXT']

CLEAN.include("ext/**/*.#{dlext}", "ext/**/.log", "ext/**/.o", "ext/**/*~", "ext/**/*#*", "ext/**/.obj", "ext/**/.def", "ext/**/.pdb")
CLOBBER.include("**/*.#{dlext}", "**/*~", "**/*#*", "**/*.log", "**/*.o", "doc/**")

spec = Gem::Specification.new do |s|
    s.name = "chipmunk"
    s.summary = "ruby bindings for the chipmunk physics engine"
    s.description = s.summary
    s.version = CHIPMUNK_VERSION
    s.author = "Scott Lembcke, Beoran, John Mair (banisterfiend)"
    s.email = 'jrmair@gmail.com'
    s.date = Time.now.strftime '%Y-%m-%d'
    s.require_path = 'lib'
    s.homepage = "http://code.google.com/p/chipmunk-physics/"
    s.platform = Gem::Platform::RUBY
    s.extensions = FileList["ext/**/extconf.rb"]
    s.files = ["Rakefile", "README", "LICENSE", "lib/chipmunk.rb"] +
        FileList["ext/**/extconf.rb", "ext/**/*.h", "ext/**/*.c"].to_a
end

Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_zip = false
    pkg.need_tar = false
end

Rake::ExtensionTask.new('chipmunk', spec) do |ext|
    ext.cross_compile = true                
    ext.cross_platform = 'i386-mswin32'     
end
