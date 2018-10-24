FROM httpd:2.4

# Need gettext for envsubst
RUN apt-get update && apt-get -y install gettext-base build-essential

# Variables.  NOTE that these are different from those used by docker compose in .envs
ENV SRC_ROOT=/opt/src \
    BASE_LOG_DIR=/var/log \
    #
    # DMP Online Service
    #
    DMP_PUMA_PORT=3000 \
    DMP_SERVICE_NAME=dmponline \
    DMP_SERVICE_PORT=80 \
    #
    # DMP Melbourne
    #
    DMP_MELBOURNE_PUMA_PORT=3020 \
    DMP_MELBOURNE_SERVICE_NAME=dmpmelbourne \
    DMP_MELBOURNE_SERVICE_PORT=2020 \
    #
    # DMP Tuuli
    #
    DMP_TUULI_PUMA_PORT=3010 \
    DMP_TUULI_SERVICE_NAME=dmptuuli \
    DMP_TUULI_SERVICE_PORT=2010 \
    #
    # DMP TuuliTest
    #
    DMP_TUULI_TEST_PUMA_PORT=3011 \
    DMP_TUULI_TEST_SERVICE_NAME=dmptuuli-test \
    DMP_TUULI_TEST_SERVICE_PORT=2011 \
    #
    # DMP Online Dev
    #
    DMP_DEV_PUMA_PORT=3001 \
    DMP_DEV_SERVICE_NAME=dmponline_dev \
    DMP_DEV_SERVICE_PORT=2001 

# Log directories (have to specify bash explicitly rather than default /bin/sh)
RUN bash -c 'mkdir -p $BASE_LOG_DIR/{$DMP_SERVICE_NAME,$DMP_MELBOURNE_SERVICE_NAME,${DMP_TUULI_SERVICE_NAME},${DMP_TUULI_TEST_SERVICE_NAME},${DMP_DEV_SERVICE_NAME}}'

# Apache config will be located in /usr/local/apache2
COPY ./compose/prod/apache/conf/httpd.conf /usr/local/apache2/conf/httpd.conf

# Copy virtual host templates across
COPY ./compose/prod/apache/sites-enabled/* /tmp/sites-enabled/

# Create sites-enabled
RUN mkdir -p /usr/local/apache2/sites-enabled/

# Interpolate variables and copy to sites-enabled
RUN envsubst < /tmp/sites-enabled/$DMP_SERVICE_NAME.dcc.ac.uk.conf > /usr/local/apache2/sites-enabled/$DMP_SERVICE_NAME.dcc.ac.uk.conf &&\
    envsubst < /tmp/sites-enabled/$DMP_MELBOURNE_SERVICE_NAME.dcc.ac.uk.conf > /usr/local/apache2/sites-enabled/$DMP_MELBOURNE_SERVICE_NAME.dcc.ac.uk.conf &&\
    envsubst < /tmp/sites-enabled/$DMP_TUULI_SERVICE_NAME.dcc.ac.uk.conf > /usr/local/apache2/sites-enabled/$DMP_TUULI_SERVICE_NAME.dcc.ac.uk.conf &&\
    envsubst < /tmp/sites-enabled/$DMP_TUULI_TEST_SERVICE_NAME.dcc.ac.uk.conf > /usr/local/apache2/sites-enabled/$DMP_TUULI_TEST_SERVICE_NAME.dcc.ac.uk.conf &&\
    envsubst < /tmp/sites-enabled/$DMP_DEV_SERVICE_NAME.dcc.ac.uk.conf > /usr/local/apache2/sites-enabled/$DMP_DEV_SERVICE_NAME.dcc.ac.uk.conf

# Copy the Apache modules and other config
COPY /compose/prod/apache/conf.modules.d/* /usr/local/apache2/conf.modules.d/
COPY /compose/prod/apache/conf.d/* /usr/local/apache2/conf.d/