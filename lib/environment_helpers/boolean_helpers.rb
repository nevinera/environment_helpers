module EnvironmentHelpers
  module BooleanHelpers
    BOOLEAN_VALUES = [true, false, nil].to_set

    def boolean(name, default: nil, required: false)
      check_default_value(:boolean, default, allow: BOOLEAN_VALUES)
      text = fetch_value(name, required: required)

      return true if truthy_text?(text)
      return false if falsey_text?(text)

      return default unless required
      fail(InvalidBooleanText, "Required boolean environment variable #{name} had inappropriate content '#{text}'")
    end

    private

    def truthy_text?(text)
      return false if text.nil?
      truthy_strings.include?(text.strip.downcase)
    end

    def falsey_text?(text)
      return false if text.nil?
      falsey_strings.include?(text.strip.downcase)
    end

    def truthy_strings
      @_truthy_strings ||=
        ENV.fetch("ENVIRONMENT_HELPERS_TRUTHY_STRINGS", "true,yes,on,enabled,enable,allow,t,y,1,ok,okay")
          .split(",")
          .to_set
    end

    def falsey_strings
      @_falsey_strings ||=
        ENV.fetch("ENVIRONMENT_HELPERS_FALSEY_STRINGS", "false,no,off,disabled,disable,deny,f,n,0,nope")
          .split(",")
          .to_set
    end
  end
end
