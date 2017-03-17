require "envelope/message-validator/version"
require "envelope/message-validator/message-validator"
require "envelope/message-validator/agent"

require 'thor'

module Envelope
  module MessageValidator
    DEFAULT_SCHEMATA_PATH=File.expand_path("../../../schemata", __FILE__)
    DEFAULT_BROKER="localhost"

    class CLI < Thor
      class_option :'schemata-path', :aliases => '-p', :type => :string, :required => false, :desc => "path to schemata files", :default => DEFAULT_SCHEMATA_PATH

      desc "validate YAML", "validates if YAML is valid"
      method_option :schema, :aliases => '-s', :type => :string, :required => false, :desc => "specify schema"

      def validate(yaml)
        Validator.new(options).validate_from_file(yaml)
      end

      desc "agent", "run as agent to provide validations via MQTT"
      method_option :'msg-broker', :aliases => '-s', :type => :string, :required => false, :desc => "MQTT broker", :default => DEFAULT_BROKER
      def agent()
        Agent.new(options).run
      end


      desc "list", "list available schemata"
      def list()
        Validator.new(options).list
      end
    end
  end
end
