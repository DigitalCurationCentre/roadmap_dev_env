#!/bin/bash

bundle check || bundle install --without mysql thin

rake db:migrate

puma config.ru
