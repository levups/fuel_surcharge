workflow "Publish a new release" {
  on = "push"
  resolves = ["Publish the gem to Rubygems"]
}

action "Is current HEAD is master?" {
  uses = "actions/bin/filter@0ac6d44"
  args = "ref refs/heads/master"
}

action "Having a new version to release?" {
  needs = "Is current HEAD is master?"
  uses = "./.github/actions/gem-publish"
  args = "should_we_release_a_new_version"
}

action "Build and publish gem" {
  needs = "Having a new version to release?"
  uses = "./.github/actions/gem-publish"
  args = "build release:rubygem_push"
  secrets = ["RUBYGEMS_AUTH_TOKEN"]
}

