module Envelope
  module MessageValidator
    class Communicator
      attr_reader :client

      def initialize(msg_broker='localhost', port=1883)
        @client = MQTT::Client.connect(msg_broker)
      end

      def sub(topic)
        puts "Subsribing to #{topic}..."
        @client.subscribe(topic)
      end

      def recv
        @client.get unless @client.queue_empty?
      end

      def get
        @client.get yield if block_given?
      end
    end
  end
end

