require_relative "./environment_helpers/access_helpers"
require_relative "./environment_helpers/string_helpers"
require_relative "./environment_helpers/boolean_helpers"
require_relative "./environment_helpers/numeric_helpers"
require_relative "./environment_helpers/file_helpers"

module EnvironmentHelpers
  Error = Class.new(::StandardError)
  MissingVariableError = Class.new(Error)
  BadDefault = Class.new(Error)

  InvalidValue = Class.new(Error)
  InvalidBooleanText = Class.new(InvalidValue)
  InvalidIntegerText = Class.new(InvalidValue)

  include AccessHelpers
  include StringHelpers
  include BooleanHelpers
  include NumericHelpers
  include FileHelpers
end

ENV.extend(EnvironmentHelpers)
