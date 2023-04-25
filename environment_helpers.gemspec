require_relative "lib/environment_helpers/version"

Gem::Specification.new do |spec|
  spec.name = "environment_helpers"
  spec.version = EnvironmentHelpers::VERSION
  spec.authors = ["Eric Mueller"]
  spec.email = ["nevinera@gmail.com"]

  spec.summary = "A set of convenience methods for accessing environment data"
  spec.description = <<~DESC
    Convenience helpers for more simply accessing data passed to applications through the
    environment that may have types and/or defaults
  DESC
  spec.homepage = "https://github.com/nevinera/environment_helpers"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.start_with?("spec") }
  end

  spec.bindir = "bin"
  spec.executables = []
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "simplecov", "~> 0.22.0"
  spec.add_development_dependency "pry", "~> 0.14"
  spec.add_development_dependency "standard", "~> 1.28"
  spec.add_development_dependency "rubocop", "~> 1.50"
end
