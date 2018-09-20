#!/bin/bash

# normalizing logging variables as required by TIER
export ENV=${ENV//[; ]/_}
export USERTOKEN=${USERTOKEN//[; ]/_}

echo "Linking secrets and config files; using authentication: $AUTHENTICATION"
ln -sf /run/secrets/m_sp-key.pem /etc/shibboleth/sp-key.pem
ln -sf /run/secrets/m_host-key.pem /etc/pki/tls/private/host-key.pem
ln -sf /etc/httpd/conf.d/midpoint.conf.auth.$AUTHENTICATION /etc/httpd/conf.d/midpoint.conf

httpd-shib-foreground &

if [ "$AUTHENTICATION" = "shibboleth" ]; then
  LOGOUT_URL_DIRECTIVE="-Dauth.logout.url=$LOGOUT_URL"
else
  LOGOUT_URL_DIRECTIVE=
fi

java -Xmx$MEM -Xms2048m -Dfile.encoding=UTF8 \
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
       -Dmidpoint.logging.console.prefix="midpoint;midpoint.log;$ENV;$USERTOKEN;" \
       -Dmidpoint.logging.console.timezone=UTC \
       -Dspring.profiles.active="`$MP_DIR/active-spring-profiles`" \
       -Dauth.sso.header=$SSO_HEADER \
       $LOGOUT_URL_DIRECTIVE \
       -Dserver.tomcat.ajp.enabled=$AJP_ENABLED \
       -Dserver.tomcat.ajp.port=$AJP_PORT \
       -jar $MP_DIR/lib/midpoint.war
