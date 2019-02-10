# GitHub Actions for conditionaly build the gem

This Action runs `rake` commands to check if a build has to be run. We use it for checking if the current version is an upgrade of the previous version.

## Usage

In a GitHub workflow, call the action with the required task(s) as argument:

```hcl
action "Build" {
  uses = "./.github/actions/build-gem"
}
```

## License

The Dockerfile and associated scripts and documentation in this project are released under the [MIT License](LICENSE).
