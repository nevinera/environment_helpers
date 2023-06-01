module EnvironmentHelpers
  module EnumerableHelpers
    VALID_TYPES = %i[strings symbols integers file_paths]

    def array(key, of: :strings, delimiter: ",", default: nil, required: false)
      check_default_type(:array, default, Array)
      check_valid_data_type(of)

      values = fetch_value(key, required: required)
      return default if values.nil?
      values.split(delimiter).map do |value|
        TYPE_HANDLERS[of].call(value)
      end
    end

    private

    def check_valid_data_type(type)
      unless VALID_TYPES.include?(type)
        fail(InvalidType, "Valid types: #{VALID_TYPES.join(", ")}. Got: #{type}.")
      end
    end

    TYPE_HANDLERS = {
      strings: ->(value) { value.to_s },
      symbols: ->(value) { value.to_sym },
      integers: ->(value) { value.to_i },
      file_paths: ->(value) { Pathname.new(value) }
    }
  end
end
