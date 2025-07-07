module EnvironmentHelpers
  module NumericHelpers
    def integer(name, default: nil, required: false)
      check_default_type(:integer, default, Integer)
      text = fetch_value(name, required: required)&.strip
      text = enforced_format(text: text, required: required)
      text&.to_i || default
    end

    private

    def enforced_format(text:, required:)
      return nil unless text
      return text if text.match?(/\A-?\d+\z/)

      # Not a "correct" integer (we accept only limited forms here)
      return nil unless required
      fail(InvalidIntegerText, "The environment vaiable '${name}' contains text that does not look like an integer")
    end
  end
end
