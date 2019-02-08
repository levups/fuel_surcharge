# GitHub Actions for Publishing Levups Ruby Gems

This Action enables arbitrary actions with the `rake` command-line client. We use it for auto publishing gem to [rubygems](https://rubygems.org/) when the version is an upgrade of the previous version.

## Usage

An workflow we use to build and publish a signed gem to the default public registry follows:

```hcl
workflow "Publish a new release" {
  on = "push"
  resolves = ["Publish"]
}

action "Check" {
  uses = "./github/actions/gem-publish"
  args = "should_we_release_a_new_version"
}

action "Test" {
  needs = "Check"
  uses = "./github/actions/gem-publish"
  args = "test"
}

action "Build" {
  needs = "Test"
  uses = "./github/actions/gem-publish"
  args = "build"
}

action "Publish" {
  needs = "Build"
  uses = "./github/actions/gem-publish"
  args = "release"
  secrets = ["RUBYGEMS_AUTH_TOKEN"]
}
```

### Secrets

  * `RUBYGEMS_AUTH_TOKEN` - **Required**. The token to use for authentication with the rubygems repository

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).
