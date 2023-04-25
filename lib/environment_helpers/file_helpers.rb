require "pathname"

module EnvironmentHelpers
  module FileHelpers
    def file_path(name, default: nil, required: false)
      check_default_type(:file_path, default, String)
      path = fetch_value(name, required: required) || default
      return nil if path.nil?
      Pathname.new(path).then do |pathname|
        pathname.exist? ? pathname : nil
      end
    end
  end
end
