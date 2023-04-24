module EnvironmentHelpers
  Error = Class.new(::StandardError)
  MissingVariableError = Class.new(Error)

  def string(name, default: nil, required: false)
    required ? fetch(name) : fetch(name, default)
  rescue KeyError
    fail(MissingVariableError, "The environment variable '#{name}' was required but not supplied")
  end
end

ENV.extend(EnvironmentHelpers)
