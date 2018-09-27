#!/bin/bash

echo "Linking secrets and config files; using authentication: $AUTHENTICATION"
ln -sf /run/secrets/m_sp-key.pem /etc/shibboleth/sp-key.pem
ln -sf /run/secrets/m_host-key.pem /etc/pki/tls/private/host-key.pem
ln -sf /etc/httpd/conf.d/midpoint.conf.auth.$AUTHENTICATION /etc/httpd/conf.d/midpoint.conf

httpd-shib-foreground
