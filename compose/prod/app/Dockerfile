# Interpolate variable in config file in separate image first
FROM alpine as Builder

RUN apk add --update --no-cache gettext

ARG SRC_ROOT=/opt/src
ARG SERVICE_NAME=dmp
ARG ROADMAP_EXTENSION_VERSION
ARG GITHUB_TOKEN
ARG RAILS_ENV
ARG PUMA_PORT

ENV RAILS_ROOT=${SRC_ROOT}/${SERVICE_NAME} 

COPY ./compose/prod/app/puma.rb /tmp/puma/
COPY ./compose/prod/app/Gemfile.custom /tmp/roadmap-extension/

RUN  envsubst < /tmp/roadmap-extension/Gemfile.custom  > /tmp/Gemfile.custom && \
     envsubst < /tmp/puma/puma.rb > /tmp/puma.rb

# Main image
FROM starefossen/ruby-node:2-10-slim

RUN apt-get update -qq && \
 apt-get install -y --no-install-recommends \
 build-essential \
 libpq-dev \
 wkhtmltopdf \
 git \
 imagemagick \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /usr/share/doc \
&& rm -rf /usr/share/man \
&& apt-get clean

ARG SRC_ROOT=/opt/src
ARG SERVICE_NAME=dmp
ARG ROADMAP_EXTENSION_VERSION
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

RUN mkdir /var/log/${SERVICE_NAME} && \
    bash -c 'mkdir -p puma/${SERVICE_NAME}/{sockets,pids,log}' 

# Copy interpolated variables in configuration files
COPY --from=Builder  /tmp/Gemfile.custom $RAILS_ROOT/Gemfile.custom
COPY --from=Builder  /tmp/puma.rb $RAILS_ROOT/config/puma.rb

RUN gem install bundler && \
    bundle install --without mysql thin test development \
     # Remove unneeded files (cached *.gem, *.o, *.c)
 && rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete 

# Precompile assets with nulldb
RUN DATABASE_URL='nulldb://nohost' bundle exec rake assets:precompile

# Remove folders not needed in resulting image
RUN rm -rf node_modules tmp/cache app/assets vendor/assets lib/assets spec

EXPOSE $PUMA_PORT

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]