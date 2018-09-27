#!/bin/bash

trap 'exitcode=$? ; error "Exiting $0 because of an error ($exitcode) occurred" ; exit $exitcode' ERR
. ../test/common.sh

echo "Stopping containers..."
docker-compose stop
echo "OK"
echo
echo "Starting containers..."
docker-compose start
test/t010-wait-for-start.sh
echo "OK"

# Eventually remove this (after this problem is fixed)
#echo "Checking for 'address already in use' message"
#(docker logs midpoint_midpoint-server_1 2>&1 | grep "ERROR Shibboleth.Listener : failed socket call (bind), result (98): Address already in use") && yellow "=== Address already in use! ===" && docker-compose down && docker-compose up --no-start && docker-compose start

echo
echo "Getting user 'administrator'..."
test/t110-get-administrator.sh
