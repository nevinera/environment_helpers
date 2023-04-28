# 'set' doesn't need requiring after ruby 3.2, but it won't hurt anything.
# And we're compatible back to 2.6
require "set" # rubocop:disable Lint/RedundantRequireStatement

require_relative "./environment_helpers/access_helpers"
require_relative "./environment_helpers/string_helpers"
require_relative "./environment_helpers/boolean_helpers"
require_relative "./environment_helpers/range_helpers"
require_relative "./environment_helpers/numeric_helpers"
require_relative "./environment_helpers/file_helpers"
require_relative "./environment_helpers/datetime_helpers"

module EnvironmentHelpers
  Error = Class.new(::StandardError)
  MissingVariableError = Class.new(Error)
  BadDefault = Class.new(Error)

  InvalidValue = Class.new(Error)
  InvalidBooleanText = Class.new(InvalidValue)
  InvalidRangeText = Class.new(InvalidValue)
  InvalidIntegerText = Class.new(InvalidValue)
  InvalidDateText = Class.new(InvalidValue)

  include AccessHelpers
  include StringHelpers
  include BooleanHelpers
  include RangeHelpers
  include NumericHelpers
  include FileHelpers
  include DatetimeHelpers
end

ENV.extend(EnvironmentHelpers)
