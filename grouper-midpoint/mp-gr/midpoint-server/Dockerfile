#
#  Building assumes midpoint-3.9-SNAPSHOT-dist.tar.gz is present in the current directory.
#

FROM tier/shibboleth_sp

MAINTAINER info@evolveum.com

# TODO switch to other appropriate Java implementation

RUN yum -y install java-1.8.0-openjdk

ARG MP_VERSION=3.9-SNAPSHOT
ARG MP_DIST_FILE=midpoint-${MP_VERSION}-dist.tar.gz

ENV MP_DIR /opt/midpoint

RUN mkdir -p ${MP_DIR}/var

COPY ${MP_DIST_FILE} ${MP_DIR}
COPY container_files/ ${MP_DIR}/var/

RUN echo 'Extracting midPoint archive...' \
 && tar xzf ${MP_DIR}/midpoint-${MP_VERSION}-dist.tar.gz -C ${MP_DIR} --strip-components=1

VOLUME ${MP_DIR}/var

ENV REPO_HOST midpoint-data
ENV REPO_PORT 3306
ENV REPO_USER root
ENV REPO_DATABASE midpoint
ENV REPO_PASSWORD_FILE /run/secrets/m_database_password.txt
ENV ENV demo
ENV USERTOKEN $MP_VERSION

CMD java -Xmx2048M -Xms2048M -Dfile.encoding=UTF8 \
       -Dmidpoint.home=$MP_DIR/var \
       -Dmidpoint.repository.database=mariadb \
       -Dmidpoint.repository.jdbcUsername=$REPO_USER \
       -Dmidpoint.repository.jdbcPasswordFile=$REPO_PASSWORD_FILE \
       -Dmidpoint.repository.jdbcUrl=jdbc:mariadb://$REPO_HOST:$REPO_PORT/$REPO_DATABASE?characterEncoding=utf8 \
       -Dmidpoint.repository.hibernateHbm2ddl=none \
       -Dmidpoint.repository.missingSchemaAction=create \
       -Dmidpoint.repository.initializationFailTimeout=60000 \
       -Dmidpoint.logging.console.enabled=true -Dmidpoint.logging.console.prefix="midpoint;midpoint.log;$ENV;$USERTOKEN;" -Dmidpoint.logging.console.timezone=UTC \
       -jar $MP_DIR/lib/midpoint.war
