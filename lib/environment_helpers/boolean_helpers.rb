module EnvironmentHelpers
  module BooleanHelpers
    TRUTHY_STRINGS = %w[true yes on enabled enable allow t y 1 ok okay].to_set
    FALSEY_STRINGS = %w[false no off disabled disable deny f n 0 nope].to_set
    BOOLEAN_VALUES = [true, false, nil].to_set

    def boolean(name, default: nil, required: false)
      check_default_value(:boolean, default, allow: [nil, true, false])
      text = fetch_value(name, required: required)

      return true if truthy_text?(text)
      return false if falsey_text?(text)

      return default unless required
      fail(InvalidBooleanText, "Required boolean environment variable #{name} had inappropriate content '#{text}'")
    end

    private

    def truthy_text?(text)
      return false if text.nil?
      TRUTHY_STRINGS.include?(text.strip.downcase)
    end

    def falsey_text?(text)
      return false if text.nil?
      FALSEY_STRINGS.include?(text.strip.downcase)
    end
  end
end
