#!/bin/bash

docker-compose build server
docker-compose run --rm server bundle install 
docker-compose run --rm server rake db:setup

