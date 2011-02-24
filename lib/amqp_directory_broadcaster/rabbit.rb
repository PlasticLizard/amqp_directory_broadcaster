require 'uri'

module AmqpDirectoryBroadcaster
  class Rabbit
    attr_accessor :host, :username, :password, :vhost, :port

    def initialize(constr=nil)
      @host = "localhost"
      @username = "guest"
      @password = "guest"
      @vhost = "/"
      @port = 5672

      if (constr =~ /amqp:\/\//)
        @uri = URI.parse(constr)
        @host =  uri.host
        @port = uri.port || 5672
        @username = uri.user || "guest"
        @password = uri.password || "guest"
        @vhost = uri.path.strip.length < 1 ? "/" : uri.path
      else
        @host = constr
      end
    end

    def to_h
      {
        :host=>host,
        :port=>port,
        :username=>username,
        :password=>password,
        :vhost=>vhost
      }
    end

  end
end
