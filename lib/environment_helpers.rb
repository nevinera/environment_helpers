require_relative "./environment_helpers/access_helpers"
require_relative "./environment_helpers/string_helpers"

module EnvironmentHelpers
  Error = Class.new(::StandardError)
  MissingVariableError = Class.new(Error)
  BadDefault = Class.new(Error)

  include AccessHelpers
  include StringHelpers
end

ENV.extend(EnvironmentHelpers)
