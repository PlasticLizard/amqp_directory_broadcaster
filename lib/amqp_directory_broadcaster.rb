require "rubygems"
require 'trollop'
require 'bunny'

$:.unshift(File.expand_path(File.dirname(__FILE__)))

require "amqp_directory_broadcaster/rabbit"

module AmqpDirectoryBroadcaster

  def self.parse_options
    opts = Trollop::options do
      opt :source, "The directory you want to publish JSON messages from", :type => String, :default=>"."
      opt :filter, "The file filter to use to select which files to send", :type => String
      opt :broker, "The uri of the AMQP broker you want to publish to", :type => String, :default=>"localhost"
      opt :exchange, "The name of the exchange you want to publish to", :type => String
      opt :type, "The type of the exchange you want to publish to", :type => String, :default => "topic"
      opt :durable, "Whether or not the exchange is durable", :default => true
      opt :routing_key, "The routing key to use when publishing messages", :type=>String, :short => '-k'
      opt :verbose, "Output volumes of exciting, play by play information. Make sure you get your soda and chips before turning on this baby.", :default => false
      opt :message_extension, "The extension that identifies message files in the source directory", :type => String, :default => "json", :short => '-x'

      opt :auto_delete, "Delete the message files after sending them", :default => true
    end
    Trollop::die :exchange, "must be specified" unless opts[:exchange]
    opts
  end

  def self.broadcast(options = nil)
    options ||= parse_options
    dir = File.expand_path(options[:source])
    filter = options[:filter] || "*.#{options[:message_extension]}"
    filter = File.join(dir,".") + "/#{filter}" #windows hack
    exchange_name = options[:exchange]
    broker_uri = options[:broker]
    broker = AmqpDirectoryBroadcaster::Rabbit.new(broker_uri)

    puts "Loading messages from #{filter}"
    puts "Sending messages to #{exchange_name} @ #{broker_uri}"

    bunny = breed(broker.to_h)
    puts "Broker Settings:#{broker.to_h.inspect}" if options[:verbose]

    begin
      exchange_options = {
        :durable => options[:durable],
        :type => options[:type].to_sym
      }

      exchange = bunny.exchange(exchange_name,exchange_options)
      Dir[filter].each do |message|
        puts "Processing message file: #{message}" if options[:verbose]
        message_text = File.read(message)
        if routing_key = options[:routing_key]
          puts "Publishing to key: #{routing_key}, message: #{message_text}" if options[:verbose]
          exchange.publish(message_text, :key => routing_key)
        else
          puts "Publishing message:#{message_text}" if options[:verbose]
          exchange.publish(message_text)
        end
        puts "Deleting #{message}" if options[:verbose]
        File.delete(message)
      end
    ensure
      bunny.stop
    end
  end

  def self.breed(options)
    b = Bunny.new(options)
    b.start
    b
  end

end



