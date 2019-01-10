#!/bin/bash

echo 'Precompiling assets'

bundle exec rake assets:precompile

echo 'About to start Puma'

bundle exec puma -C config/puma.rb
