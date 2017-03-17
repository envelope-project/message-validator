require 'colorize'
require 'kwalify'
require 'yaml'
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

      def validate_from_file(yaml_file)
        yaml_str = File.read(yaml_file)
        results = validate(yaml_str, '')

        if (results['validations'].length == 1)
          results['validations'].each do |schema_name, results|
            unless results["result"]
              puts "The following errors were found for '#{schema_name}':"
             results["errors"].each { |error| puts error }
            else
              puts "Validation against #{schema_name}...#{'SUCCESS'.green}"
            end
          end
        else
          results['validations']
.each do |schema_name, results|
            print "Validation against #{schema_name}..."
            if results["result"]
              puts "SUCCESS".green
            else
              puts "FAIL".red
            end
          end
        end
      end

      def validate(yaml_str, schema)
        yaml = Kwalify::Yaml.load(yaml_str)
        results = {}
        schema = ".*" if (schema.empty? || schema == "anyschema")
        schemata = @schemata.select { |e| e =~ /#{schema}/ }
        if schemata.empty?
          results["result"] = "failure"
          results["error"] = "Could not find schema '#{schema}'"
          return results
        else
          results["result"] = "success"
          results["validations"] = {}
        end
        schemata.each do |schema|
          schema_name = schema.yaml_path_to_name
          validator = Envelope::MessageValidator::Hooks.new(Kwalify::Yaml.load_file(schema))
          errors = validator.validate(yaml)
          if (errors && !errors.empty?)
            results["validations"][schema_name] = {"result" => false, "errors" => []}
            errors.each do |error|
              results["validations"][schema_name]["errors"] << error.message
            end
          else
            results["validations"][schema_name] = {"result" => true}
          end
        end

        results
      end
    end
  end
end
