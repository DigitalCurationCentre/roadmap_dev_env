FROM httpd:2.4

# Need gettext for envsubst
RUN apt-get update && \
 apt-get -y install \
 gettext-base \
 build-essential \
 --no-install-recommends shibboleth-sp2-utils \
 libapache2-mod-shib2 \
 supervisor \
 && rm -r /var/lib/apt/lists/*

# Build args from compose
ARG SERVICE_NAME=dmp
ARG PUMA_PORT
ARG SERVICE_PORT

ENV SRC_ROOT=/opt/src \
    BASE_LOG_DIR=/var/log 

# Log directories (have to specify bash explicitly rather than default /bin/sh)
RUN bash -c 'mkdir -p $BASE_LOG_DIR/${SERVICE_NAME}'

# Copy virtual host templates across
COPY ./compose/prod/apache/sites-enabled/vhost_template.conf /tmp/sites-enabled/${SERVICE_NAME}.dcc.ac.uk.conf
COPY ./compose/prod/apache/conf/httpd.conf /tmp/conf/httpd.conf

# Create sites-enabled
RUN mkdir -p /usr/local/apache2/sites-enabled/

# Interpolate variables and copy to sites-enabled
RUN envsubst < /tmp/sites-enabled/${SERVICE_NAME}.dcc.ac.uk.conf > /usr/local/apache2/sites-enabled/${SERVICE_NAME}.dcc.ac.uk.conf
RUN envsubst < /tmp/conf/httpd.conf > /usr/local/apache2/conf/httpd.conf

# Copy the Apache modules and other config
COPY /compose/prod/apache/conf.modules.d/* /usr/local/apache2/conf.modules.d/
COPY /compose/prod/apache/conf.d/* /usr/local/apache2/conf.d/

#####################################

# TODO shib daemon
COPY supervisord/supervisor-app.conf /etc/supervisor/conf.d/

# Start supervisord in foreground
CMD ["supervisord", "-n"]
