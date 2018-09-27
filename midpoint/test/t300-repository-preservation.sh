#!/bin/bash

USER=test300
trap 'exitcode=$? ; error "Exiting $0 because of an error ($exitcode) occurred" ; exit $exitcode' ERR
. ../test/common.sh

docker ps
echo Checking health before action
test/t100-check-health.sh
docker ps

echo "Adding user '${USER}'..."
curl -k --user administrator:5ecr3t -H "Content-Type: application/xml" -X POST "https://localhost:8443/midpoint/ws/rest/users" -d @- << EOF
<user>
  <name>${USER}</name>
</user>
EOF
echo "OK"

echo "Searching for user '${USER}'..."
curl -k --user administrator:5ecr3t -H "Content-Type: application/xml" -X POST "https://localhost:8443/midpoint/ws/rest/users/search" -d @- << EOF >/tmp/${USER}.xml
<q:query xmlns:q="http://prism.evolveum.com/xml/ns/public/query-3">
    <q:filter>
        <q:equal>
            <q:path>name</q:path>
            <q:value>${USER}</q:value>
        </q:equal>
    </q:filter>
</q:query>
EOF
echo "OK"

grep -q "<name>${USER}</name>" </tmp/${USER}.xml || (error "User ${USER} was not found" ; exit 1)
rm /tmp/${USER}.xml

echo "Bringing the containers down"
docker-compose down

echo "Re-creating the containers"
docker-compose up --no-start
docker-compose start
test/t010-wait-for-start.sh

echo "Searching for user '${USER}' again..."
curl -k --user administrator:5ecr3t -H "Content-Type: application/xml" -X POST "https://localhost:8443/midpoint/ws/rest/users/search" -d @- << EOF >/tmp/${USER}.xml
<q:query xmlns:q="http://prism.evolveum.com/xml/ns/public/query-3">
    <q:filter>
        <q:equal>
            <q:path>name</q:path>
            <q:value>${USER}</q:value>
        </q:equal>
    </q:filter>
</q:query>
EOF
echo "OK"

grep -q "<name>${USER}</name>" </tmp/${USER}.xml || (error "User ${USER} was not found (after restart) -- but continuing" ; exit 0)
rm /tmp/${USER}.xml
