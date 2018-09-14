FROM ruby:2.4.4

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev gettext-base

# Set enviroment variables
ENV BASE_LOG_DIR=/var/log/dmp \
    SRC_ROOT=/opt/src \
    #
    # DMP Online Service
    #
    PUMA_PORT=3000 \
    SERVICE_NAME=dmponline 

# Construct rails root
ENV RAILS_ROOT=${SRC_ROOT}/${SERVICE_NAME}

# Set working directory
WORKDIR $RAILS_ROOT

# Adding project files
COPY ./roadmap/ . 
COPY ./roadmap-branding/${SERVICE_NAME}/config/  ./config 
COPY ./roadmap-branding/${SERVICE_NAME}/lib/  ./lib

# Copy custom fonts
COPY ./roadmap-branding/node_modules/customfonts ./lib/assets/node_modules/customfonts

# ***** TODO Revist and try installing npm as part of multistage build *****
# install npm etc
RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash - && apt-get install -y nodejs

WORKDIR $RAILS_ROOT/lib/assets
RUN npm install && npm run bundle -- -p

# Copy public files next
WORKDIR $RAILS_ROOT

COPY  ./roadmap-branding/${SERVICE_NAME}/public/  ./public

# Interpolate variables in puma configuration file
COPY ./compose/prod/app/puma.rb /tmp/puma/
RUN envsubst < /tmp/puma/puma.rb > $RAILS_ROOT/config/puma.rb

COPY ./roadmap-branding/${SERVICE_NAME}/app/views/branded app/views/branded

RUN bundle install
# RUN bundle install --jobs 20 --retry 5 --without development test 

# Create directories that Puma expects
RUN bash -c 'mkdir -p puma/${SERVICE_NAME}/{sockets,pids,log}'

# RUN bundle exec rake DATABASE_URL=postgres:does_not_exist assets:precompile
# RUN bundle exec rake assets:precompile
EXPOSE $PUMA_PORT

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]