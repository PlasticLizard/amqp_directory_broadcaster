# encoding: UTF-8
require File.expand_path('../lib/amqp_directory_broadcaster/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'amqp_directory_broadcaster'
  s.homepage = 'http://github.com/PlasticLizard/amqp_directory_broadcaster'
  s.summary = 'Read messages from a directory and send them to an AMQP exchange'
  s.require_path = 'lib'
  s.authors = ['Nathan Stults']
  s.email = ['hereiam@sonic.net']
  s.version = AmqpDirectoryBroadcaster::VERSION
  s.platform = Gem::Platform::RUBY
  s.files = Dir.glob("{lib,test,bin}/**/*") + %w[LICENSE.txt README]
  s.executables = ["broadcast_directory"]
  s.default_executable = %q{broadcast_directory}

  s.add_dependency 'bunny'
  s.add_dependency 'trollop'

  s.add_development_dependency 'rake'
end

