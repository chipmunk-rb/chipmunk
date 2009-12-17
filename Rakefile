begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "chipmunk-ffi"
    gem.rubyforge_project = "chipmunk-ffi"
    gem.summary = %Q{FFI bindings for chipmunk physics lib.}
    gem.description = %Q{FFI bindings for chipmunk physics lib.}
    gem.email = "shawn42@gmail.com"
    gem.homepage = "http://shawn42.github.com/chipmunk-ffi"
    gem.authors = ["Shawn Anderson"]
    gem.add_dependency "ffi", ">= 0.6.0"
    gem.add_dependency "nice-ffi"
    gem.add_development_dependency "rspec"
    gem.add_development_dependency "jeweler"
    gem.test_files = FileList['{spec,test}/**/*.rb']
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
desc "Run all rspecs"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/*_spec.rb']
end
task :default => :spec

# vim: syntax=Ruby
