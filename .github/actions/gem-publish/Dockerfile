FROM ruby:2.6

LABEL version="1.0.0"
LABEL repository="https://github.com/levups/fuel_surcharge/.github/actions/gem-publish"
LABEL homepage="https://github.com/levups/fuel_surcharge/.github/actions/gem-publish"
LABEL maintainer="Bob Maerten <bob@levups.com>"

LABEL com.github.actions.name="GitHub Action for publishing the gem to rubygems"
LABEL com.github.actions.description="Wraps the rake CLI to trigger common tasks."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="red"

RUN gem install rake bundler

COPY LICENSE README.md /
COPY "entrypoint.sh" "/entrypoint.sh"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["help"]
