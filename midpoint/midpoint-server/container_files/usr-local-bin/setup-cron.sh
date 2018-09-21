#!/bin/bash

CRONFILE=/opt/tier/cronfile

if [ "$TIER_BEACON_ENABLED" == "true" ]; then
    echo "#send daily \"beacon\" to central" > ${CRONFILE}
#    echo $(expr $RANDOM % 59) $(expr $RANDOM % 3) "* * * /usr/local/bin/send-tier-beacon.sh >> /tmp/logcrond 2>&1" >> ${CRONFILE}
    echo "* * * * * /usr/local/bin/send-tier-beacon.sh >> /tmp/logcrond 2>&1" >> ${CRONFILE}		# for testing
else
    echo "#beacon is disabled" > ${CRONFILE}
fi

chmod 644 ${CRONFILE}
crontab ${CRONFILE}
