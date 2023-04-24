require_relative "./environment_helpers/access_helpers"
require_relative "./environment_helpers/string_helpers"
require_relative "./environment_helpers/boolean_helpers"

module EnvironmentHelpers
  Error = Class.new(::StandardError)
  MissingVariableError = Class.new(Error)
  BadDefault = Class.new(Error)
  InvalidValue = Class.new(Error)
  InvalidBooleanText = Class.new(InvalidValue)

  include AccessHelpers
  include StringHelpers
  include BooleanHelpers
end

ENV.extend(EnvironmentHelpers)
