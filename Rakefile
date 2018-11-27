require "bundler/gem_tasks"
require "github_changelog_generator/task"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.user                 = "levups"
  config.project              = "fuel_surcharge"
  config.add_issues_wo_labels = false
end

task default: :test
