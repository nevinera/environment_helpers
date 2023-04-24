module WithEnvironment
  def with_env(overrides)
    around(:each) do |ex|
      orig_env = ENV.to_h
      ENV.update(overrides)
      begin
        ex.run
      ensure
        ENV.replace(orig_env)
      end
    end
  end
end

RSpec.configure do |config|
  config.extend WithEnvironment
end
