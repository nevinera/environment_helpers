module EnvironmentHelpers
  module NumericHelpers
    def integer(name, default: nil, required: false)
      check_default_type(:integer, default, Integer)
      text = fetch_value(name, required: required)
      text&.to_i || default
    end
  end
end
