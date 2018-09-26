#!/bin/bash

trap 'exitcode=$? ; error "Exiting midpoint/test.sh because of an error ($exitcode) occurred" ; exit $exitcode' ERR

cd "$(dirname "$0")"
. ../test/common.sh

heading "Composing midPoint..."
docker-compose up --no-start
ok "midPoint composed OK"
echo

heading "Starting midPoint..."
docker-compose start
ok "midPoint started OK"
echo

heading "Test 010: Waiting for midPoint to start..."
test/t010-wait-for-start.sh
ok "midPoint started"
echo

heading "Test 100: Checking health via HTTP..."
test/t100-check-health.sh
ok "Health check passed"
echo

heading "Test 110: Getting user 'administrator'..."
test/t110-get-administrator.sh
ok "User 'administrator' retrieved and checked"
echo

heading "Test 120: Adding and getting a user..."
test/t120-add-get-user.sh
ok "OK"
echo

heading "Test 200: Stop/start cycle..."
test/t200-stop-start.sh
ok "OK"
echo

#heading "Test 300: Checking repository preservation across compose down/up..."
#test/t300-repository-preservation.sh
#ok "OK"
#echo
