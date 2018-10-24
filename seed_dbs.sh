#!/bin/bash
# Convenience to seed all dbs

# set -e

function seedDbs {
    containers=( "dmponline_app" "dmpmelbourne_app" "dmptuuli_app" "dmponline_dev_app" "dmptuuli_test_app" )
    
    for i in "${containers[@]}"
    do
        command="docker-compose -f docker-compose.prod.yml run --rm $i rake db:setup"
        echo Running $command
        eval $command
    done
}

seedDbs
