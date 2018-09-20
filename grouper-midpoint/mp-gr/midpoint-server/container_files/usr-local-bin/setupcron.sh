#!/bin/bash

CRONTMPFILE=/tmp/cronfile

echo "#send daily \"beacon\" to central" > ${CRONTMPFILE}
#echo $(expr $RANDOM % 59) $(expr $RANDOM % 3) "* * * /usr/local/bin/sendtierbeacon.sh >> /tmp/logcrond 2>&1" >> ${CRONTMPFILE}
echo 47 "* * * * /usr/local/bin/sendtierbeacon.sh >> /dev/fd/8 2>&1" >> ${CRONTMPFILE}
chmod 644 ${CRONTMPFILE}
crontab ${CRONTMPFILE}
