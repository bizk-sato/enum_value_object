require "active_support/concern"

module EnumValueObject
  module EnumExtender
    extend ActiveSupport::Concern

    class_methods do
      def enum(definitions)
        value_object = definitions.delete(:value_object) { false }

        super(**definitions)

        return unless value_object

        definitions.each do |name, values|
          next unless values.is_a?(Hash)

          define_method("#{name}_object") do
            value = send(name)
            klass_name = value.to_s.camelize
            klass = Object.const_get(klass_name)
            klass.new
          rescue NameError
            raise EnumValueObject::Error.new "You need to define #{klass} klass to use value object for enum"
          end
        end
      end
    end
  end
end
