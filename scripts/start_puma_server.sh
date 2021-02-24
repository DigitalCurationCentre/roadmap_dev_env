#!/bin/bash
set -e

bundle check || bundle update 

bundle exec rails assets:precompile

touch log/production.log

bundle exec puma -C config/puma.rb
