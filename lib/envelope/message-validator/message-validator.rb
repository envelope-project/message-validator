require 'colorize'
require 'kwalify'
require 'envelope/message-validator/hooks'

class String
  def yaml_path_to_name
    File.basename(self, ".*")
  end
end

module Envelope
  module MessageValidator
    class Validator
      def initialize(options)
        if (options[:schema])
          raise "ERROR: Could not find '#{options[:schema]}'. Abort!" unless File.file?(options[:schema])
          @schemata = [options[:schema]]
        else
          schemata_path = options[:'schemata-path']
          @schemata = Dir.glob("#{schemata_path}/**/*.yml")
        end
      end

      # lists available schemata
      def list
        puts "The following schemata are available for validation:"
        @schemata.each { |schema| puts schema.yaml_path_to_name }
      end

      def validate(yaml)
        document = Kwalify::Yaml.load_file(yaml)
        @schemata.each do |schema|
          print "Validate '#{yaml}' against '#{schema.yaml_path_to_name}'... "
          validator = Envelope::MessageValidator::Hooks.new(Kwalify::Yaml.load_file(schema))
          @errors = validator.validate(document)
          if (@errors && !@errors.empty?)
            puts "FAIL".red
          else
            puts "SUCCESS".green
          end
        end

        if (@schemata.length == 1)
          puts "The following errors were found for '#{@schemata[0].yaml_path_to_name}':" if (@errors && !@errors.empty?)
          @errors.each { |error| puts error }
        end
      end
    end
  end
end
