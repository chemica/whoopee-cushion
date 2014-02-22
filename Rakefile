require 'bundler/gem_tasks'
currdir = File.dirname(__FILE__)
require currdir+ '/test/benchmarks'

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = "test/*_test.rb"
end


desc 'Run the benchmarks'
task :benchmark do
  benchmarks
end