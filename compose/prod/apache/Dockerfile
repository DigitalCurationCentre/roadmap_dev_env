FROM httpd:2.4

# Need gettext for envsubst
RUN apt-get update && apt-get -y install gettext-base build-essential

# Build args from compose
ARG SRC_ROOT=/opt/src
ARG PUMA_PORT
ARG SERVICE_NAME
ARG SERVICE_PORT

ENV SRC_ROOT=/opt/src \
    BASE_LOG_DIR=/var/log 

# Log directories (have to specify bash explicitly rather than default /bin/sh)
RUN bash -c 'mkdir -p $BASE_LOG_DIR/${SERVICE_NAME}'

# Apache config will be located in /usr/local/apache2
# COPY ./compose/prod/apache/conf/httpd.conf /usr/local/apache2/conf/httpd.conf

# Copy virtual host templates across
COPY ./compose/prod/apache/sites-enabled/vhost_template.conf /tmp/sites-enabled/${SERVICE_NAME}.dcc.ac.uk.conf
COPY ./compose/prod/apache/conf/httpd.conf /tmp/conf/httpd.conf

# Create sites-enabled
RUN mkdir -p /usr/local/apache2/sites-enabled/

# Interpolate variables and copy to sites-enabled
RUN envsubst < /tmp/sites-enabled/${SERVICE_NAME}.dcc.ac.uk.conf > /usr/local/apache2/sites-enabled/${SERVICE_NAME}.dcc.ac.uk.conf
RUN envsubst < /tmp/conf/httpd.conf > /usr/local/apache2/conf/httpd.conf

RUN ls -l /usr/local/apache2/sites-enabled

# Copy the Apache modules and other config
COPY /compose/prod/apache/conf.modules.d/* /usr/local/apache2/conf.modules.d/
COPY /compose/prod/apache/conf.d/* /usr/local/apache2/conf.d/
