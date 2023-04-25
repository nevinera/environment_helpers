require "date"

module EnvironmentHelpers
  module DatetimeHelpers
    def date(name, format: "%Y-%m-%d", default: nil, required: false)
      check_default_type(:date, default, Date)
      text = fetch_value(name, required: required)
      date = parse_date_from(text, format: format)

      return date if date
      return default unless required
      fail(InvalidDateText, "Required date environment variable #{name} had inappropriate content '#{text}'")
    end

    private

    def parse_date_from(text, format:)
      return nil if text.nil?
      Date.strptime(text, format)
    rescue ArgumentError
      nil
    end
  end
end
