FROM ruby:2.4.4

RUN apt-get update -qq && \
 apt-get install -y \
 build-essential \
 libpq-dev \
 wkhtmltopdf \
 gettext-base \
 imagemagick \
 && curl -sL https://deb.nodesource.com/setup_10.x |  \
 bash - && apt-get install -y \
 nodejs \
&& rm -rf /var/lib/apt/lists/*

# Build args are passed in via compose file
ARG SRC_ROOT=/opt/src
ARG SERVICE_NAME=dmp
ARG PUMA_PORT
ARG EXTENSION_VERSION
ARG GITHUB_TOKEN
ARG RAILS_ENV

# Get rails env (production/development from environment variable)
ENV RAILS_ENV=${RAILS_ENV}

# Construct rails root and set required env variables
ENV RAILS_ROOT=${SRC_ROOT}/${SERVICE_NAME} 
ENV BUNDLE_GEMFILE=Gemfile.custom
ENV BUNDLE_GITHUB__COM=${GITHUB_TOKEN}

# Set working directory
WORKDIR $RAILS_ROOT

# Adding project files
COPY ./roadmap/ . 

# ******* Temporary to try and get things working *********
COPY ./roadmap-branding/dmponline/  .

# Copy database and secrets templates
COPY ./config/ ./config/ 
# Copy startup script
COPY ./compose/prod/app/precompile_assets_and_start_puma.sh /usr/local/bin

# Copy custom fonts
# COPY ./roadmap-branding/node_modules/customfonts ./lib/assets/node_modules/customfonts

# WORKDIR $RAILS_ROOT/lib/assets
# RUN npm install && npm run bundle -- -p  # IS THIS STILL REQUIRED?
# RUN npm install && npm run bundle -- -p --no-watch
# WORKDIR $RAILS_ROOT

# Interpolate variables in configuration files
COPY ./compose/prod/app/puma.rb /tmp/puma/
COPY ./Gemfile.custom /tmp/roadmap-extension/

RUN envsubst < /tmp/puma/puma.rb > $RAILS_ROOT/config/puma.rb && \
    envsubst < /tmp/roadmap-extension/Gemfile.custom  > $RAILS_ROOT/Gemfile.custom && \
    mkdir /var/log/${SERVICE_NAME} && \
    bash -c 'mkdir -p puma/${SERVICE_NAME}/{sockets,pids,log}' 

RUN npm install --global yarn && \
    gem install bundler && \
    bundle install --without development test && \
    rake webpacker:yarn_install

# TODO:  Translations?

EXPOSE $PUMA_PORT

# We use a script to start rather than start puma directly so that we can precompile
# the assets.  Not possible to to it during build phase as db not available
CMD ["/usr/local/bin/precompile_assets_and_start_puma.sh"]
