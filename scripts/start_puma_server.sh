#!/bin/bash
set -e

bundle install --with rollbar

bundle exec rake assets:precompile

# rm log/development.log
rm log/production.log
touch log/production.log

# touch log/development.log

bundle exec puma -C config/puma.rb

