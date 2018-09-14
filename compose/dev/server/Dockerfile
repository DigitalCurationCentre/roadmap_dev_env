FROM ruby:2.4.4

RUN apt-get update -qq && \
  apt-get install -y \
  build-essential \
  git \
  libgmp3-dev \
  libpq-dev \
  libsqlite3-dev \
  wkhtmltopdf \
  postgresql-client

WORKDIR /usr/src/app

COPY ./roadmap/Gemfile* ./

RUN bundle install

VOLUME /usr/src/app

EXPOSE 3000

CMD ["rails", "s", "-b", "0.0.0.0"]