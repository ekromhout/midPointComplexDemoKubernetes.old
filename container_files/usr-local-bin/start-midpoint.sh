#!/bin/bash

java -Xmx$MP_MEM -Xms2048m -Dfile.encoding=UTF8 \
       -Dmidpoint.home=$MP_DIR/var \
       -Dmidpoint.repository.database=$REPO_DATABASE_TYPE \
       -Dmidpoint.repository.jdbcUsername=$REPO_USER \
       -Dmidpoint.repository.jdbcPassword_FILE=$REPO_PASSWORD_FILE \
       -Dmidpoint.repository.jdbcUrl="`$MP_DIR/repository-url`" \
       -Dmidpoint.repository.hibernateHbm2ddl=none \
       -Dmidpoint.repository.missingSchemaAction=$REPO_MISSING_SCHEMA_ACTION \
       -Dmidpoint.repository.upgradeableSchemaAction=$REPO_UPGRADEABLE_SCHEMA_ACTION \
       $(if [ -n "$REPO_SCHEMA_VERSION_IF_MISSING" ]; then echo "-Dmidpoint.repository.schemaVersionIfMissing=$REPO_SCHEMA_VERSION_IF_MISSING"; fi) \
       $(if [ -n "$REPO_SCHEMA_VARIANT" ]; then echo "-Dmidpoint.repository.schemaVariant=$REPO_SCHEMA_VARIANT"; fi) \
       -Dmidpoint.repository.initializationFailTimeout=60000 \
       -Dmidpoint.keystore.keyStorePassword_FILE=$MP_KEYSTORE_PASSWORD_FILE \
       -Dmidpoint.logging.alt.enabled=true \
       -Dmidpoint.logging.alt.filename=/tmp/logmidpoint \
       -Dmidpoint.logging.alt.timezone=UTC \
       -Dspring.profiles.active="`$MP_DIR/active-spring-profiles`" \
       -Dauth.sso.header=$SSO_HEADER \
       $(if [ "$AUTHENTICATION" = "shibboleth" ]; then echo "-Dauth.logout.url=$MP_LOGOUT_URL"; fi) \
       -Dserver.tomcat.ajp.enabled=$AJP_ENABLED \
       -Dserver.tomcat.ajp.port=$AJP_PORT \
       -Dlogging.path=/tmp/logtomcat \
       -jar $MP_DIR/lib/midpoint.war &>/tmp/logmidpoint-console
