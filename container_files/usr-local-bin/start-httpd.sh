#!/bin/bash

echo "Linking secrets"
for filepath in /run/secrets/*; do
  label_file=`basename $filepath`
  if [ "$label_file" == "mp_sp-key.pem" ]; then
    ln -sf /run/secrets/mp_sp-key.pem /etc/shibboleth/sp-key.pem
  elif [ "$label_file" == "mp_host-key.pem" ]; then
    ln -sf /run/secrets/mp_host-key.pem /etc/pki/tls/private/host-key.pem
  fi
done

echo "Linking config files; using authentication: $AUTHENTICATION"
ln -sf /etc/httpd/conf.d/midpoint.conf.auth.$AUTHENTICATION /etc/httpd/conf.d/midpoint.conf
ln -sf /etc/httpd/conf.d/shib.conf.auth.$AUTHENTICATION /etc/httpd/conf.d/shib.conf
ln -sf /etc/httpd/conf.modules.d/00-shib.conf.auth.$AUTHENTICATION /etc/httpd/conf.modules.d/00-shib.conf

case $AUTHENTICATION in
  shibboleth)
    echo "*** Starting httpd WITH Shibboleth support"
    httpd-shib-foreground
    ;;
  internal)
    echo "*** Starting httpd WITHOUT Shibboleth support"
    rm -f /etc/httpd/logs/httpd.pid /run/httpd/httpd.pid
    httpd -DFOREGROUND
    ;;
  *)
    echo "*** Couldn't start httpd: unsupported AUTHENTICATION variable value: '$AUTHENTICATION'"
    sleep infinity
    ;;
esac
