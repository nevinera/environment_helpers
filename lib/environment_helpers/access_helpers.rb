module EnvironmentHelpers
  module AccessHelpers
    private

    def fetch_value(name, required:)
      required ? fetch(name) : fetch(name, nil)
    rescue KeyError
      fail(MissingVariableError, "The environment variable '#{name}' was required but not supplied")
    end

    def check_default_type(context, value, *types)
      return if value.nil?
      return if types.any? { |t| value.is_a?(t) }
      fail(BadDefault, "Inappropriate default value for ENV.#{context}")
    end

    def check_default_value(context, value, allow:)
      return if allow.include?(value)
      fail(BadDefault, "Inappropriate default value for ENV.#{context}")
    end
  end
end
