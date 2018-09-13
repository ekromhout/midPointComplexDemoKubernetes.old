#!/bin/sh

linkSecrets(){
    for filepath in /run/secrets/*; do
    	local label_file=`basename $filepath`
    	local file=$(echo $label_file| cut -d'_' -f 2)

    	if [[ $label_file == shib_* ]]; then
            ln -sf /run/secrets/$label_file /etc/shibboleth/$file
    	elif [ "$label_file" == "host-key.pem" ]; then
            ln -sf /run/secrets/host-key.pem /etc/pki/tls/private/host-key.pem
    	fi
     done
}