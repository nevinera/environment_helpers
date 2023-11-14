module EnvironmentHelpers
  module StringHelpers
    def string(name, default: nil, required: false)
      fetch_value(name, required: required) || default
    end

    def symbol(name, default: nil, required: false)
      check_default_type(:symbol, default, Symbol)
      string(name, default: default&.to_s, required: required)&.to_sym
    end
  end
end
