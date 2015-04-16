require './lib/version'

Gem::Specification.new do |s|
  s.name = "chipmunk"
  s.summary = "Enhanced ruby bindings for the chipmunk game physics engine."
  s.description = s.summary + " "
  s.version = CP::VERSION
  s.author = "Scott Lembcke, Beoran, John Mair (banisterfiend), Shawn Anderson"
  s.email = 'beoran@rubyforge.org'
  s.date = Time.now.strftime '%Y-%m-%d'
  s.require_path = 'lib'
  s.homepage = "https://github.com/beoran/chipmunk"
  s.license = 'MIT'

  s.platform = Gem::Platform::RUBY
  s.extensions = Dir["ext/**/extconf.rb"]
  s.files = ["Rakefile", "README", "LICENSE", "lib/chipmunk.rb", "lib/version.rb"] +
      Dir["ext/**/extconf.rb", "ext/**/*.h", "ext/**/*.c"]
end
