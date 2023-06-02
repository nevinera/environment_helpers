module EnvironmentHelpers
  module EnumerableHelpers
    VALID_TYPES = %i[strings symbols integers]

    def array(key, of: :strings, delimiter: ",", default: nil, required: false)
      check_default_type(:array, default, Array)
      check_valid_data_type!(of)
      check_default_data_types!(default, of)

      values = fetch_value(key, required: required)
      return default if values.nil?

      values.split(delimiter).map { |value| value.send(TYPE_HANDLERS[of]) }
    end

    private

    def check_valid_data_type!(type)
      unless VALID_TYPES.include?(type)
        fail(InvalidType, "Valid types: #{VALID_TYPES.join(", ")}. Got: #{type}.")
      end
    end

    def check_default_data_types!(default, type)
      invalid = Array(default).reject { |val| val.is_a? TYPE_MAP[type] }

      unless invalid.empty?
        fail(BadDefault, "Default array contains values not of type `#{type}': #{invalid.join(", ")}")
      end
    end

    TYPE_HANDLERS = {
      integers: :to_i,
      strings: :to_s,
      symbols: :to_sym
    }

    TYPE_MAP = {
      integers: Integer,
      strings: String,
      symbols: Symbol
    }
  end
end
