#!/bin/bash

curl -k --user administrator:5ecr3t -H "Content-Type: application/xml" -X GET "https://localhost:8443/midpoint/ws/rest/users/00000000-0000-0000-0000-000000000002" >/tmp/admin.xml
grep -q "<name>administrator</name>" </tmp/admin.xml || (echo "User 'administrator' was not found or not retrieved correctly" ; exit 1)
rm /tmp/admin.xml
