#
#  Just a demonstration of how to flexibly use MariaDB running in a separate container.
#  It requires v3.9devel-269-gbdd3017 or later.
#
#  Features:
#   - see docker-compose.yml
#
#  Limitations (will be resolved):
#   - image is derived from Evolveum's dockerization
#   - mariadb uses default database of 'registry' and default user of 'root'
#   - JDBC password is present as plaintext
#
#  Building:      (assumes midpoint-3.9-SNAPSHOT-dist.tar.gz is present in the current directory)
#
#    docker build -t midpoint .
#    docker stack deploy -c docker-compose.yml mp
#

FROM openjdk:8-jdk-alpine

MAINTAINER info@evolveum.com

ARG MP_VERSION=3.9-SNAPSHOT
ARG MP_DIST_FILE=midpoint-${MP_VERSION}-dist.tar.gz

ENV MP_DIR /opt/midpoint
ENV REPO_HOST mariadb
ENV REPO_PORT 3306
ENV REPO_USER root
ENV REPO_PASSWORD 123321

RUN mkdir -p ${MP_DIR}/var

COPY ${MP_DIST_FILE} ${MP_DIR}

RUN echo 'Extracting midPoint archive...' \
 && tar xzf ${MP_DIR}/midpoint-${MP_VERSION}-dist.tar.gz -C ${MP_DIR} --strip-components=1

VOLUME ${MP_DIR}/var

CMD java -Xmx2048M -Xms2048M -Dfile.encoding=UTF8 \
       -Dmidpoint.home=$MP_DIR/var \
       -Dmidpoint.repository.database=mariadb \
       -Dmidpoint.repository.jdbcUsername=$REPO_USER \
       -Dmidpoint.repository.jdbcPassword=$REPO_PASSWORD \
       -Dmidpoint.repository.jdbcUrl=jdbc:mariadb://$REPO_HOST:$REPO_PORT/registry?characterEncoding=utf8 \
       -Dmidpoint.repository.hibernateHbm2ddl=none \
       -Dmidpoint.repository.missingSchemaAction=create \
       -Dmidpoint.repository.initializationFailTimeout=60000 \
       -jar $MP_DIR/lib/midpoint.war
