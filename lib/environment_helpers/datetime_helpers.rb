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

    def date_time(name, format: :iso8601, default: nil, required: false)
      check_default_type(:date_time, default, DateTime)
      text = fetch_value(name, required: required)
      dt = parse_date_time_from(text, format: format)

      return dt if dt
      return default unless required
      fail(InvalidDateTimeText, "Require date_time environment variable #{name} had inappropriate content '#{text}'")
    end

    private

    def parse_date_from(text, format:)
      return nil if text.nil?
      Date.strptime(text, format)
    rescue ArgumentError
      nil
    end

    def parse_date_time_from(text, format:)
      if text.nil?
        nil
      elsif format == :iso8601
        iso8601_date_time(text)
      elsif format == :unix
        unix_date_time(text)
      elsif format.is_a?(String)
        strptime_date_time(text, format: format)
      else
        fail(BadFormat, "ENV.date_time requires either a strptime format string, :unix, or :iso8601")
      end
    end

    def iso8601_date_time(text)
      DateTime.iso8601(text)
    rescue
      nil
    end

    def unix_date_time(text)
      DateTime.strptime(text, "%s")
    rescue
      nil
    end

    def strptime_date_time(text, format:)
      DateTime.strptime(text, format)
    rescue
      nil
    end
  end
end
