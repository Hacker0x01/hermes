require 'rake/testtask'
require "rake/extensiontask"

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test

Rake::ExtensionTask.new("hermes") do |ext|
  ext.lib_dir = "lib/hermes"
end
