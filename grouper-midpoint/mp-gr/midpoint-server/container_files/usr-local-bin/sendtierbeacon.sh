#!/bin/bash

LOGHOST="localhost"
LOGPORT="80"

if [ -s /opt/tier/env.bash ]; then
  . /opt/tier/env.bash
fi

messagefile="/tmp/beaconmsg"

if [ -z "$TIER_BEACON_OPT_OUT" ]; then
    cat > $messagefile <<EOF
{
    "msgType"          : "TIERBEACON",
    "msgName"          : "TIER",
    "msgVersion"       : "1.0",
    "tbProduct"        : "MIDPOINT",
    "tbProductVersion" : "$MP_VERSION",
    "tbTIERRelease"    : "$TIER_RELEASE",
    "tbMaintainer"     : "$TIER_MAINTAINER"
}
EOF

    curl -s -XPOST "${LOGHOST}:${LOGPORT}/" -H 'Content-Type: application/json' -T $messagefile 1>/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "tier_beacon;none;$ENV;$USERTOKEN;"`date`"; TIER beacon sent"
    else
        echo "tier_beacon;none;$ENV;$USERTOKEN;"`date`"; Failed to send TIER beacon"
    fi

    rm -f $messagefile 1>/dev/null 2>&1

fi
