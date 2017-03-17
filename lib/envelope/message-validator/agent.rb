require 'mqtt'
require 'socket'
require 'envelope/message-validator/message-validator'
require 'envelope/message-validator/Communicator'

AGENT_TOPIC="envelope/" + `hostname`.strip + "/validator"

module Envelope
  module MessageValidator
    class Agent
      def initialize(options)
        @validator = Validator.new(options)
        @communicator = Communicator.new(options[:'msg-broker'])
        @communicator.sub("#{AGENT_TOPIC}/validate/#")
      end

      def run
          @communicator.client.get do |topic, message|
            topic.slice! "#{AGENT_TOPIC}/validate"
            topic_parts = topic.split("/").drop(1)
            schema = topic_parts[0]
            id = topic_parts.drop(1).join("/")
            results = @validator.validate(message, schema) unless (message.class == NilClass)
            @communicator.client.publish("#{AGENT_TOPIC}/result/#{id}", results.to_yaml)
          end
        puts "Goodbye."
      end
    end
  end
end
