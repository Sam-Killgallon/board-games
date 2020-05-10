FROM ruby:2.6.5-slim-buster as base

# build-essential - For compiling native dependencies
# curl            - For installing nodejs + yarn
# gnupg2          - For installing nodejs + yarn
# imagemagick     - For generating thumbnails and manipulating images
# nodejs          - For compiling JS with webpacker
# libpq-dev       - For installing 'pg' gem to talk to postgresql
# tzdata          - For time zone support in rails
# yarn            - For installing JS packages
ARG PRODUCTION_PACKAGES="build-essential imagemagick nodejs libpq-dev tzdata yarn"
ARG APP_ROOT=/app

RUN apt-get update \
    && apt-get install -y curl gnupg2 \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get -y install ${PRODUCTION_PACKAGES}

# Required while on ruby2.6, can be removed in 2.7
RUN gem install bundler:2.1.4

RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}

ENTRYPOINT ["docker_scripts/entrypoint.sh"]
# Will bind to PORT evironment variable, or 3000 by default
CMD ["rails", "server", "-b", "0.0.0.0"]

FROM base as development

# bash - For a shell
ARG DEVELOPMENT_PACKAGES="bash"
# chromium + chromium-driver - For running headless chrome tests
ARG TESTING_PACKAGES="chromium chromium-driver"

RUN apt-get update && apt-get -y install ${DEVELOPMENT_PACKAGES} ${TESTING_PACKAGES}

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 8 --retry 3 \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

FROM base as production

COPY Gemfile Gemfile.lock ./

RUN BUNDLE_WITHOUT="development test" bundle install --jobs 8 --retry 3 \
    && bundle clean --force \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY . ./
ENV RAILS_ENV production
RUN SECRET_KEY_BASE=$(rails secret) rails assets:precompile
