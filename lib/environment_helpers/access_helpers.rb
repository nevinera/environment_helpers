module EnvironmentHelpers
  module AccessHelpers
    private

    def fetch_value(name, required:)
      required ? fetch(name) : fetch(name, nil)
    rescue KeyError
      fail(MissingVariableError, "The environment variable '#{name}' was required but not supplied")
    end
  end
end
