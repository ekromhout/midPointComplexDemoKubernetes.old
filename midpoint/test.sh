#!/bin/bash

trap 'exitcode=$? ; echo "Exiting midpoint/test.sh because of an error ($exitcode) occurred" ; exit $exitcode' ERR

cd "$(dirname "$0")"
. ../test/common.sh

yellow "*** Composing midPoint..."
docker-compose up --no-start
green "==> midPoint composed OK"
echo
yellow "*** Starting midPoint..."
docker-compose start
green "==> midPoint started OK"
echo
yellow "*** Waiting for midPoint to start..."
test/wait-for-start.sh
green "==> midPoint started"
echo
yellow "*** Checking health via HTTP..."
(set -o pipefail ; curl -k -f https://localhost:8443/midpoint/actuator/health | tr -d '[:space:]' | grep -q "\"status\":\"UP\"")
green "==> Health is OK"
