FROM ruby:2.4.4

RUN apt-get update -qq && \
 apt-get install -y build-essential libpq-dev gettext-base imagemagick \
 && curl -sL https://deb.nodesource.com/setup_10.x |  bash - && apt-get install -y nodejs 

# Build args are passed in via compose file
ARG SRC_ROOT=/opt/src
ARG SERVICE_NAME=dmp
ARG PUMA_PORT
ARG EXTENSION_VERSION
ARG GITHUB_TOKEN
ARG RAILS_ENV

# Get rails env (production/development from environment variable)
ENV RAILS_ENV=${RAILS_ENV}

# Construct rails root
ENV RAILS_ROOT=${SRC_ROOT}/${SERVICE_NAME}

# Set working directory
WORKDIR $RAILS_ROOT

# Adding project files
COPY ./roadmap/ . 

# Copy service specific branding
# COPY ./roadmap-branding/${SERVICE_NAME}/  .

# ******* Temporary to try and get things working *********
# COPY ./roadmap-branding/dmponline/  .

# Copy database and secrets templates
COPY ./config/ ./config/ 

# Copy custom Gemfile for multitenancy
COPY ./Gemfile.custom ./

# Copy custom fonts
# COPY ./roadmap-branding/node_modules/customfonts ./lib/assets/node_modules/customfonts

# WORKDIR $RAILS_ROOT/lib/assets
# RUN npm install && npm run bundle -- -p  # IS THIS STILL REQUIRED?
# RUN npm install && npm run bundle -- -p --no-watch
# WORKDIR $RAILS_ROOT

# Install yarn
RUN npm install --global yarn

# Interpolate variables in configuration files
COPY ./compose/prod/app/puma.rb /tmp/puma/
COPY ./Gemfile.custom /tmp/roadmap-extension/

RUN envsubst < /tmp/puma/puma.rb > $RAILS_ROOT/config/puma.rb
RUN envsubst < /tmp/roadmap-extension/Gemfile.custom  > $RAILS_ROOT/Gemfile.custom

RUN mkdir /var/log/${SERVICE_NAME}

# TODO:  Translations?

# Create directories that Puma expects
RUN bash -c 'mkdir -p puma/${SERVICE_NAME}/{sockets,pids,log}'

ENV BUNDLE_GEMFILE=Gemfile.custom
ENV BUNDLE_GITHUB__COM=${GITHUB_TOKEN}

RUN gem install bundler

RUN bundle install

RUN rake webpacker:yarn_install

EXPOSE $PUMA_PORT

COPY ./compose/prod/app/precompile_assets_and_start_puma.sh /usr/local/bin

# We use a script to start rather than start puma directly so that we can precompile
# the assets.  Not possible to to it during build phase as db not available
CMD ["/usr/local/bin/precompile_assets_and_start_puma.sh"]
