FROM ruby:2.4.4

RUN apt-get update -qq && \
 apt-get install -y --no-install-recommends \
 build-essential \
 libpq-dev \
 wkhtmltopdf \
 gettext-base \
 imagemagick \
 && curl -sL https://deb.nodesource.com/setup_10.x |  \
 bash - && apt-get install -y \
 nodejs \
&& rm -rf /var/lib/apt/lists/* \
&& rm -Rf /usr/share/doc \
&& rm -Rf /usr/share/man \
&& apt-get clean


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

# Copy database and secrets templates
COPY ./config/ ./config/ 

# TODO: Temporary only
# COPY ./roadmap-branding/dmponline/config/branding.yml config/branding.yml

WORKDIR $RAILS_ROOT/config
RUN mv branding.yml.sample branding.yml
WORKDIR $RAILS_ROOT

# Copy database and secrets templates
# COPY ./config/ ./config/ 

# Copy startup script
COPY ./compose/prod/app/precompile_assets_and_start_puma.sh /usr/local/bin

# Interpolate variables in configuration files
COPY ./compose/prod/app/puma.rb /tmp/puma/
COPY ./Gemfile.custom /tmp/roadmap-extension/

RUN envsubst < /tmp/puma/puma.rb > $RAILS_ROOT/config/puma.rb && \
    envsubst < /tmp/roadmap-extension/Gemfile.custom  > $RAILS_ROOT/Gemfile.custom && \
    mkdir /var/log/${SERVICE_NAME} && \
    bash -c 'mkdir -p puma/${SERVICE_NAME}/{sockets,pids,log}' 

RUN npm install --global yarn && \
    gem install bundler

RUN bundle install --without mysql thin

# TODO:  Translations?

EXPOSE $PUMA_PORT

# We use a script to start rather than start puma directly so that we can precompile
# the assets.  Not possible to to it during build phase as db not available
CMD ["/usr/local/bin/precompile_assets_and_start_puma.sh"]