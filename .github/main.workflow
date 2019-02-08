workflow "Publish a new release" {
  on = "push"
  resolves = ["Publish the gem to Rubygems"]
}

action "Having a new version to release?" {
  uses = "./.github/actions/gem-publish"
  args = "should_we_release_a_new_version"
}

action "Run the test suite" {
  needs = "Having a new version to release?"
  uses = "./.github/actions/gem-publish"
  args = "test"
}

action "Build gem" {
  needs = "Run the test suite"
  uses = "./.github/actions/gem-publish"
  args = "build"
}

action "Publish the gem to Rubygems" {
  needs = "Build gem"
  uses = "./.github/actions/gem-publish"
  args = "release"
  secrets = ["RUBYGEMS_AUTH_TOKEN"]
}