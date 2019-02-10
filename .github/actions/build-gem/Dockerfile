FROM ruby:2.6

LABEL version="1.0.0"
LABEL repository="https://github.com/levups/fuel_surcharge/.github/actions/ruby-rake"
LABEL homepage="https://github.com/levups/fuel_surcharge/.github/actions/ruby-rake"
LABEL maintainer="Bob Maerten <bob@levups.com>"

LABEL com.github.actions.name="GitHub Action for running rake build task"
LABEL com.github.actions.description="Wraps the rake CLI to trigger common tasks."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="orange"

RUN gem install rake bundler http github_changelog_generator

COPY LICENSE README.md /
COPY "entrypoint.sh" "/entrypoint.sh"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
