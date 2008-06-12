require "rake"
require "rake/testtask"
require "rake/rdoctask"

PLUGIN_NAME = "microformat"


desc "Default: run unit tests."
task :default => :test


desc "Test the #{PLUGIN_NAME} plugin."
Rake::TestTask.new(:test) do |task|
  task.libs << "lib"
  task.pattern = "test/**/*_test.rb"
  task.verbose = true
end


desc "Generate documentation for the #{PLUGIN_NAME} plugin."
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = PLUGIN_NAME
  rdoc.options << "--line-numbers"
  rdoc.options << "--inline-source"
  rdoc.rdoc_files.include("README")
  rdoc.rdoc_files.include("lib/**/*.rb")
end
