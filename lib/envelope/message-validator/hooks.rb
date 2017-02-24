require 'kwalify'

module Envelope
  module MessageValidator
    class Hooks < Kwalify::Validator
      def validate_hook(value, rule, path, errors)
        case rule.name

        # the vm-config of start tasks requires either 'xml' or 'vm-name'
        when 'start-vm-config'
          keys = value.keys
          if (keys & ['xml', 'vm-name']).empty?
            msg = "you either have to specify 'xml' or 'vm-name'."
            errors << Kwalify::ValidationError.new(msg, path)
          end

        # the vm-config of stop tasks requires either 'regex' or 'vm-name'
        when 'start-vm-config'
          keys = value.keys
          if (keys & ['regex', 'vm-name']).empty?
            msg = "you either have to specify 'xml' or 'vm-name'."
            errors << Kwalify::ValidationError.new(msg, path)
          end

        end
      end
    end
  end
end

