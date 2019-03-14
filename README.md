# roadmap_dev_env

A docker environment to run roadmap project. 

## Build

```
$ git clone https://github.com/DMPRoadmap/roadmap.git
$ docker-compose build server
```

If you want to populate the db with the seeds data, please type:

```
$ docker-compose run --rm server rake db:setup
```

In contrast, if you already have a backup db file, please type the following commands:
```
$ docker-compose run --rm -v "<PATH_TO_YOUR_SQL_FILE>":/tmp/backup.sql server /bin/bash # Substitute <PATH_TO_YOUR_SQL_FILE> with the location of your backup file
$ rake db:drop
$ rake db:create
$ psql "dbname=${POSTGRES_DB} host=db user=${POSTGRES_USER} password=${POSTGRES_PASSWORD}" < /tmp/backup.sql
$ exit
```

## Updated for latest Docker setup

Can load db dumps in the following manner:

```
$ cat dmponline.psql | docker exec -i roadmap_dev_env_db_1 sh -c 'psql -U ${POSTGRES_USER} ${POSTGRES_DB}'
```

```
$ gunzip < dmponline.psql.gz | docker exec -i roadmap_dev_env_db_1 sh -c 'psql -U ${POSTGRES_USER} ${POSTGRES_DB}'
```

Then, run migrations:

```
$ docker-compose -f docker-compose.prod.yml run --rm dmp_app rake db:migrate
``` 


## Run

```
$ docker-compose up -d
```

## Run Tests

In order to run ruby/rails tests, please type:

```
$ docker-compose run --rm server rake test
```

## Stop

```
$ docker-compose down
```

## Connect to rails console

```
$ docker-compose run --rm server rails c
```


