require "bundler/gem_tasks"
require "github_changelog_generator/task"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  latest_release = `git tag --sort=committerdate | tail -n 1`.strip
  next_release   = "v#{FuelSurcharge::VERSION}"

  config.user                 = "levups"
  config.project              = "fuel_surcharge"
  config.future_release       = next_release if next_release > latest_release
  config.add_issues_wo_labels = false
end

task default: :test
