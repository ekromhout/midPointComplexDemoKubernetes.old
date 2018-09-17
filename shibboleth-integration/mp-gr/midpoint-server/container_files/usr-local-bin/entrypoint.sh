#!/bin/bash

. /usr/local/bin/library.sh
linkSecrets

. /usr/local/bin/library.sh
checkMidpointSecurityProfile


httpd-shib-foreground & 

java -Xmx2048M -Xms2048M -Dfile.encoding=UTF8 \
       -Dmidpoint.home=$MP_DIR/var \
       -Dmidpoint.repository.database=mariadb \
       -Dmidpoint.repository.jdbcUsername=$REPO_USER \
       -Dmidpoint.repository.jdbcPasswordFile=$REPO_PASSWORD_FILE \
       -Dmidpoint.repository.jdbcUrl=jdbc:mariadb://$REPO_HOST:$REPO_PORT/$REPO_DATABASE?characterEncoding=utf8 \
       -Dmidpoint.repository.hibernateHbm2ddl=none \
       -Dmidpoint.repository.missingSchemaAction=create \
       -Dmidpoint.repository.initializationFailTimeout=60000 \
       -Dmidpoint.logging.console.enabled=true -Dmidpoint.logging.console.prefix="midpoint;midpoint.log;$ENV;$USERTOKEN;" -Dmidpoint.logging.console.timezone=UTC \
       -Dspring.profiles.active=$ACTIVE_PROFILE \
       -Dauth.sso.header=$SSO_HEADER \
       -Dauth.logout.url="$LOGOUT_URL" \
       -Dserver.tomcat.ajp.enabled=$AJP_ENABLED \
       -Dserver.tomcat.ajp.port=$AJP_PORT \
       -jar $MP_DIR/lib/midpoint.war
