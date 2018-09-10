#
#  Building assumes midpoint-3.9-SNAPSHOT-dist.tar.gz is present in the current directory.
#

FROM tier/shibboleth_sp

MAINTAINER info@evolveum.com

# TODO switch to other appropriate Java implementation

RUN yum -y install java-1.8.0-openjdk

# Build arguments

ARG MP_VERSION=3.9-SNAPSHOT
ARG MP_DIST_FILE=midpoint-${MP_VERSION}-dist.tar.gz

ENV MP_DIR=/opt/midpoint

# Copying files

RUN mkdir -p ${MP_DIR}/var
COPY ${MP_DIST_FILE} ${MP_DIR}
COPY container_files/ ${MP_DIR}/
RUN echo 'Extracting midPoint archive...' \
 && tar xzf ${MP_DIR}/midpoint-${MP_VERSION}-dist.tar.gz -C ${MP_DIR} --strip-components=1

VOLUME ${MP_DIR}/var

# Repository parameters

ENV REPO_HOST midpoint-data
ENV REPO_PORT 3306
ENV REPO_USER root
ENV REPO_DATABASE midpoint
ENV REPO_JDBC_URL default
ENV REPO_PASSWORD_FILE /run/secrets/m_database_password.txt
ENV REPO_DATABASE_TYPE mariadb

ENV KEYSTORE_PASSWORD_FILE /run/secrets/m_keystore_password.txt

# Logging parameters

ENV COMPONENT midpoint
ENV LOGFILE midpoint.log
ENV ENV demo
ENV USERTOKEN $MP_VERSION

# Other parameters

ENV MEM 2048M

# Execution

CMD java -Xmx$MEM -Xms2048M -Dfile.encoding=UTF8 \
       -Dmidpoint.home=$MP_DIR/var \
       -Dmidpoint.repository.database=$REPO_DATABASE_TYPE \
       -Dmidpoint.repository.jdbcUsername=$REPO_USER \
       -Dmidpoint.repository.jdbcPassword_FILE=$REPO_PASSWORD_FILE \
       -Dmidpoint.repository.jdbcUrl="`$MP_DIR/repository-url`" \
       -Dmidpoint.repository.hibernateHbm2ddl=none \
       -Dmidpoint.repository.missingSchemaAction=create \
       -Dmidpoint.repository.initializationFailTimeout=60000 \
       -Dmidpoint.keystore.keyStorePassword_FILE=$KEYSTORE_PASSWORD_FILE \
       -Dmidpoint.logging.console.enabled=true \
       -Dmidpoint.logging.console.prefix="`$MP_DIR/log-prefix`" \
       -Dmidpoint.logging.console.timezone=UTC \
       -jar $MP_DIR/lib/midpoint.war
