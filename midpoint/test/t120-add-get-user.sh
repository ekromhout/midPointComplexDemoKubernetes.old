#!/bin/bash

trap 'exitcode=$? ; error "Exiting $0 because of an error ($exitcode) occurred" ; exit $exitcode' ERR
. ../test/common.sh

echo "Adding user 'test120'..."
curl -k --user administrator:5ecr3t -H "Content-Type: application/xml" -X POST "https://localhost:8443/midpoint/ws/rest/users" -d @- << EOF
<user>
  <name>test120</name>
</user>
EOF
echo "OK"

echo "Searching for user 'test120'..."
curl -k --user administrator:5ecr3t -H "Content-Type: application/xml" -X POST "https://localhost:8443/midpoint/ws/rest/users/search" -d @- << EOF >/tmp/test120.xml
<q:query xmlns:q="http://prism.evolveum.com/xml/ns/public/query-3">
    <q:filter>
        <q:equal>
            <q:path>name</q:path>
            <q:value>test120</q:value>
        </q:equal>
    </q:filter>
</q:query>
EOF
echo "OK"

grep -q "<name>test120</name>" </tmp/test120.xml || (error "Retrieved XML is not as expected" ; exit 1)
rm /tmp/test120.xml
