# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "fuel_surcharge/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = "~> 2.3"

  spec.name    = "fuel_surcharge"
  spec.version = FuelSurcharge::VERSION
  spec.authors = ["Bob Maerten", "Clément Joubert"]
  spec.email   = ["bob@levups.com", "clement@levups.com"]

  spec.summary     = "Retrieve current month's Transporters' fuel surcharge"
  spec.description = "A simple gem to fetch transporters data every month."

  spec.homepage = "https://rubygems.org/gems/fuel_surcharge"
  spec.license  = "MIT"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/levups/fuel_surcharge/issues",
    "changelog_uri" => "https://github.com/levups/fuel_surcharge/blob/master/CHANGELOG.md",
    "homepage_uri" => "https://rubygems.org/gems/fuel_surcharge",
    "source_code_uri" => "https://github.com/levups/fuel_surcharge"
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|.github)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "http", "~> 4.0"

  spec.add_development_dependency "bundler", ">= 1.17"
  spec.add_development_dependency "github_changelog_generator", "~> 1.14"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-stub_any_instance", "~> 1.0"
  spec.add_development_dependency "rake", "~> 12.3"
  # We it is mature, we'll switch to the "standard" gem
  spec.add_development_dependency "relaxed-rubocop", "~> 2.3.1"
  spec.add_development_dependency "rubocop", "~> 0.62"
end
