require 'rubygems'
require 'rake'
require 'rake/testtask'

require File.expand_path('../lib/amqp_directory_broadcaster/version', __FILE__)

desc 'Builds the gem'
task :build do
  sh "gem build amqp_directory_broadcaster.gemspec"
end

desc 'Builds and installs the gem'
task :install => :build do
  sh "gem install tritech-#{AmqpDirectoryBroadcaster::VERSION}"
end

desc 'Tags version, pushes to remote, and pushes gem'
task :release => :build do
  sh "git tag v#{AmqpDirectoryBroadcaster::VERSION}"
  sh "git push origin master"
  sh "git push origin v#{AmqpDirectoryBroadcaster::VERSION}"
  sh "gem push tritech-#{AmqpDirectoryBroadcaster::VERSION}.gem"
end


Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
end

task :default => :test
