# frozen_string_literal: true

require_relative "enum_value_object/version"
require_relative "enum_value_object/enum_extender"
require "active_support"

ActiveSupport.on_load(:active_record) do
  include EnumValueObject::EnumExtender
end

module EnumValueObject
  class Error < StandardError; end
  # Your code goes here...
end
