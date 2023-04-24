module EnvironmentHelpers
  def string(name, default: nil)
    fetch(name, default)
  end
end

ENV.extend(EnvironmentHelpers)
