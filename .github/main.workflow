workflow "Publish a new release" {
  on = "push"
  resolves = ["Publish gem to rubygems.org"]
}

action "Is current HEAD is master?" {
  uses = "actions/bin/filter@0ac6d44"
  args = "ref refs/heads/master"
}

action "Having a new version to build?" {
  needs = "Is current HEAD is master?"
  uses = "./.github/actions/build-gem"
}

action "Publish gem to rubygems.org" {
  needs = "Having a new version to build?"
  uses = "scarhand/actions-ruby@947af2c"
  args = "push pkg/*.gem"
  secrets = ["RUBYGEMS_AUTH_TOKEN"]
}

