# frozen_string_literal: true

require "bundler/gem_tasks"
require "github_changelog_generator/task"
require "http"
require "json"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

desc "Check if a gem release is required"
task :should_we_release_a_new_version do
  response = HTTP.get("https://rubygems.org/api/v1/gems/fuel_surcharge.json")
  unless response.code == 200
    puts "Unable to fetch rubygems version"
    puts response.inspect
    exit 1
  end
  gem_release = JSON.parse(response.to_s).dig("version")

  if FuelSurcharge::VERSION == gem_release
    puts "No release required"
    exit 78
  else
    puts "Let's release the v#{FuelSurcharge::VERSION}!"
  end
end

task default: :test
