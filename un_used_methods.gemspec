# frozen_string_literal: true

require_relative "lib/un_used_methods/version"

Gem::Specification.new do |spec|
  spec.name = "un_used_methods"
  spec.version = UnUsedMethods::VERSION
  spec.authors = ["Dhamo1107"]
  spec.email = ["dhamodharansathish4533@gmail.com"]

  spec.summary       = "A gem to identify and list unused methods in your Rails application."
  spec.description   = "The un_used_methods gem scans your Rails application to find methods defined in models, controllers and helpers that are not used anywhere else in the application. This helps you clean up your codebase by identifying dead code."
  spec.homepage      = "https://github.com/Dhamo1107/un_used_methods"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"]   = "https://github.com/Dhamo1107/un_used_methods"
  spec.metadata["changelog_uri"]     = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile]) ||
        f.end_with?("#{spec.name}-#{spec.version}.gem")
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Add development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.21"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
