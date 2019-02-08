workflow "Publish a new release" {
  on = "push"
  resolves = ["Publish"]
}

action "Check" {
  uses = "./.github/actions/gem-publish"
  args = "should_we_release_a_new_version"
}

action "Test" {
  needs = "Check"
  uses = "./.github/actions/gem-publish"
  args = "test"
}

action "Build" {
  needs = "Test"
  uses = "./.github/actions/gem-publish"
  args = "build"
}

action "Publish" {
  needs = "Build"
  uses = "./.github/actions/gem-publish"
  args = "release"
  secrets = ["RUBYGEMS_AUTH_TOKEN"]
}
