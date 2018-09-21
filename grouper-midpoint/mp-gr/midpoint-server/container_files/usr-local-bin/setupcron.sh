#!/bin/bash

CRONFILE=/opt/tier/cronfile

/opt/tier/setenv.sh

echo "#send daily \"beacon\" to central" > ${CRONFILE}
echo $(expr $RANDOM % 59) $(expr $RANDOM % 3) "* * * /usr/local/bin/sendtierbeacon.sh >> /tmp/logcrond 2>&1" >> ${CRONFILE}
chmod 644 ${CRONFILE}
crontab ${CRONFILE}
