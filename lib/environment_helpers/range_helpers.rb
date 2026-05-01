module EnvironmentHelpers
  module RangeHelpers
    def integer_range(name, default: nil, required: false)
      check_default_type(:integer_range, default, Range)
      check_range_endpoint(:integer_range, default.begin) if default
      check_range_endpoint(:integer_range, default.end) if default

      text = fetch_value(name, required: required)
      range = text ? parse_range_from(text) : nil
      return range if range
      return default unless required
      fail(InvalidRangeText, "Required Integer Range environment variable #{name} had inappropriate content '#{text}'")
    end

    private

    def check_range_endpoint(context, value)
      return if value.is_a?(Integer)
      fail(BadDefault, "Invalid endpoint for default range of #{context} - must be Integer")
    end

    def parse_range_from(text)
      if text =~ /\A(-?\d+)(\.\.\.?)(-?\d+)\z/
        lower_bound, separator, upper_bound = $1.to_i, $2, $3.to_i
      elsif text =~ /\A(\d+)-(\d+)\z/
        lower_bound, separator, upper_bound = $1.to_i, "..", $2.to_i
      else
        return nil
      end

      (separator == "...") ? (lower_bound...upper_bound) : (lower_bound..upper_bound)
    end
  end
end
