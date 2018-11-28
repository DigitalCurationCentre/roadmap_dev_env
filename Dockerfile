FROM ruby:2.4.4
ARG precompileassets

# Dependancies
RUN apt-get update -qq && \
  apt-get install -y \
  build-essential \
  git \
  libgmp3-dev \
  libpq-dev \
  wkhtmltopdf \
  postgresql-client \
  gettext

ARG INSTALL_PATH=/usr/src/app
ENV INSTALL_PATH $INSTALL_PATH

WORKDIR $INSTALL_PATH

# install yarn+node from packages
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get install -y nodejs
RUN apt-get update && apt-get install -y yarn

# re-build from here if Gemfile or .lock change
# COPY .env ./
COPY ./roadmap/Gemfile* ./
# RUN if [ -e Gemfile.custom ] then export
RUN gem install bundler
RUN bundle install --without mysql thin

# re-build from here if package.json or yarn.lock change
COPY ./roadmap/package.json .
COPY ./roadmap/yarn.lock .
RUN yarn install --ignore-optional

# COPY roadmap/ .

# TODO: maybe need to precompile
# COPY scripts/conditional_asset_precompile ./conditional_asset_precompile
# RUN ./conditional_asset_precompile $precompileassets

# TODO: define volume
# VOLUME $INITIAL_PATH/node_modules/
#RUN  ./node_modules /tmp/node_modules


# TODO: expose correct port
EXPOSE 3000
EXPOSE 3035

# TODO: command or run things?
