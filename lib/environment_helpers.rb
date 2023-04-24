module EnvironmentHelpers
  def string(name, default: nil, required: false)
    required ? fetch(name) : fetch(name, default)
  end
end

ENV.extend(EnvironmentHelpers)
