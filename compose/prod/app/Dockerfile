FROM ruby:2.4.4

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev gettext-base

# TODO multistage build to install npm?  The following works for now.
RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash - && apt-get install -y nodejs

# Build args are passed in via compose file
ARG SRC_ROOT=/opt/src
ARG PUMA_PORT
ARG SERVICE_NAME

# Construct rails root
ENV RAILS_ROOT=${SRC_ROOT}/${SERVICE_NAME}
ENV RAILS_ENV='production'

# Set working directory
WORKDIR $RAILS_ROOT

# Adding project files
COPY ./roadmap/ . 

# Add missing puma gem
RUN echo "gem 'puma'" >> Gemfile

# Copy service specific branding
COPY ./roadmap-branding/${SERVICE_NAME}/  .

# Copy database and secrets templates
COPY ./config/ ./config/ 

# Copy custom fonts
COPY ./roadmap-branding/node_modules/customfonts ./lib/assets/node_modules/customfonts

WORKDIR $RAILS_ROOT/lib/assets

RUN npm install && npm run bundle -- -p

WORKDIR $RAILS_ROOT

# Interpolate variables in puma configuration file
COPY ./compose/prod/app/puma.rb /tmp/puma/
RUN envsubst < /tmp/puma/puma.rb > $RAILS_ROOT/config/puma.rb

RUN mkdir /var/log/${SERVICE_NAME}

# TODO:  Need to deal with translations

RUN bundle install
# RUN bundle install --jobs 20 --retry 5 --without development test 

# Create directories that Puma expects
RUN bash -c 'mkdir -p puma/${SERVICE_NAME}/{sockets,pids,log}'

# RUN bundle exec rake DATABASE_URL=postgres:does_not_exist assets:precompile
# RUN bundle exec rake assets:precompile
EXPOSE $PUMA_PORT

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]