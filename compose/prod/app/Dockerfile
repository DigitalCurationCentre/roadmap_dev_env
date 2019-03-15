FROM starefossen/ruby-node:2-10-slim

RUN apt-get update -qq && \
 apt-get install -y --no-install-recommends \
 build-essential \
 libpq-dev \
 wkhtmltopdf \
 gettext-base \
 git \
 imagemagick \
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

WORKDIR $RAILS_ROOT/config
RUN mv branding.yml.sample branding.yml
WORKDIR $RAILS_ROOT

# Interpolate variables in configuration files
COPY ./compose/prod/app/puma.rb /tmp/puma/
COPY ./compose/prod/app/Gemfile.custom /tmp/roadmap-extension/

RUN envsubst < /tmp/puma/puma.rb > $RAILS_ROOT/config/puma.rb && \
    envsubst < /tmp/roadmap-extension/Gemfile.custom  > $RAILS_ROOT/Gemfile.custom && \
    mkdir /var/log/${SERVICE_NAME} && \
    bash -c 'mkdir -p puma/${SERVICE_NAME}/{sockets,pids,log}' 

RUN gem install bundler && \
    bundle install --without mysql thin

# Precompile assets with nulldb
RUN DATABASE_URL='nulldb://nohost' bundle exec rake assets:precompile

EXPOSE $PUMA_PORT

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]