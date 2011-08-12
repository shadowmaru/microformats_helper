require "rake"
require "rake/testtask"
require "rake/rdoctask"

PLUGIN_NAME = "microformats"


desc "Default: run unit tests."
task :default => :test

begin
  require 'jeweler'
  Jeweler::Tasks.new do |jewel|
    jewel.name = 'microformats_helper'
    jewel.summary = 'Helper to render microformats structures (eg hcard).'
    jewel.email = ['shadow11@gmail.com']
    jewel.homepage = 'http://github.com/shadow11/microformats_helper/tree/master'
    jewel.description = 'Helper to render microformats structures (eg hcard).'
    jewel.authors = ["Ricardo Shiota Yasuda"]
    jewel.files = FileList["lib/**/*.rb", "*.rb", "LICENSE", "README.rdoc"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end


desc "Test the #{PLUGIN_NAME} plugin."
Rake::TestTask.new(:test) do |task|
  task.libs << "lib"
  task.pattern = "test/*_test.rb"
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
