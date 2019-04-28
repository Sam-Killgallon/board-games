FROM ruby:2.6.0

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -yf \
      # For running javascript
      nodejs \
      # For javascript package installation
      yarn \
      # For the database
      postgresql-client \
      # For building native extensions
      build-essential \
      # For chromedriver, which gets installed by the 'chromedriver-helper' gem
      libnss3 \
      # For browser tests
      chromium \
      vim

RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 8 --frozen && rm /usr/local/bundle/config

COPY package.json yarn.lock ./
RUN yarn install --pure-lockfile

# Copy the main application.
COPY . ./

# Only precompile assets when building for production, workaround
# SECRET_KEY_BASE being required when trying to compile assets
ARG RAILS_ENV=production
RUN (if [ "$RAILS_ENV" = "production" ] ; then SECRET_KEY_BASE=`bundle exec rails secret` bundle exec rails assets:precompile ; else true ; fi)

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
ENTRYPOINT ["docker_scripts/entrypoint.sh"]
# Will bind to PORT environment variable, or 3000 by default
CMD ["rails", "server", "-b", "0.0.0.0"]
