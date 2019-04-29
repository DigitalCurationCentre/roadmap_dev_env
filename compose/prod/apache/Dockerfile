FROM unicon/shibboleth-sp

# Gettext needed from envsubst command below
RUN yum -y install gettext && \
export LD_LIBRARY_PATH=/opt/shibboleth/lib64:$LD_LIBRARY_PATH

COPY ./compose/prod/apache/shibboleth/* /etc/shibboleth/

# Copy the Apache modules and other config
COPY /compose/prod/apache/conf.modules.d/* /etc/httpd/conf.modules.d/
COPY /compose/prod/apache/conf.d/* /etc/httpd/conf.d/

RUN chown -R shibd:shibd /etc/shibboleth/

# Build args from compose
ARG SERVICE_NAME=dmp
ARG PUMA_PORT
ARG SERVICE_PORT

ENV SRC_ROOT=/opt/src \
    BASE_LOG_DIR=/var/log 

# Copy virtual host templates across
COPY ./compose/prod/apache/sites-enabled/vhost_template.conf /tmp/sites-enabled/${SERVICE_NAME}.dcc.ac.uk.conf
COPY ./compose/prod/apache/conf/httpd.conf /tmp/conf/httpd.conf

# Interpolate variables and copy to sites-enabled
RUN mkdir -p /etc/httpd/sites-enabled/ && \
    bash -c 'mkdir -p $BASE_LOG_DIR/${SERVICE_NAME}' && \
    envsubst < /tmp/sites-enabled/${SERVICE_NAME}.dcc.ac.uk.conf > /etc/httpd/sites-enabled/${SERVICE_NAME}.dcc.ac.uk.conf && \
    envsubst < /tmp/conf/httpd.conf > /etc/httpd/conf/httpd.conf

# Copy the Apache modules and other config
COPY /compose/prod/apache/conf.modules.d/* /etc/httpd/conf.modules.d/
COPY /compose/prod/apache/conf.d/* /etc/httpd/conf.d/