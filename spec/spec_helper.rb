require "rspec"

if ENV["SIMPLECOV"] || ENV["CI"]
  require "simplecov"
  SimpleCov.start do
    enable_coverage :branch
  end

  SimpleCov.minimum_coverage line: 100, branch: 100
end

require File.expand_path("../../lib/environment_helpers", __FILE__)
gem_root = File.expand_path("../..", __FILE__)
support_glob = File.join(gem_root, "spec", "support", "**", "*.rb")
Dir[support_glob].sort.each { |f| require f }

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  config.mock_with :rspec
  config.order = "random"
  config.tty = true
end
