module EnvironmentHelpers
  module StringHelpers
    def string(name, default: nil, required: false)
      fetch_value(name, required: required) || default
    end
  end
end
