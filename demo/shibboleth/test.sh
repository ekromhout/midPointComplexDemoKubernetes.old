#!/bin/bash

trap 'exitcode=$? ; error "Exiting $0 because of an error ($exitcode) occurred" ; exit $exitcode' ERR

cd "$(dirname "$0")"
. ../../test/common.sh

heading "Cleaning up containers and volumes if they exist"
docker-compose down -v || true
ok "Done"
echo

heading "Composing and starting Shibboleth..."
docker-compose up --build -d
ok "OK"
echo

# TODO wait for Shib to start

heading "Composing and starting midPoint..."
pushd ../../midpoint
MPDIR=`pwd`
docker-compose down -v || true
env AUTHENTICATION=shibboleth docker-compose up --build -d
popd
$MPDIR/test/t010-wait-for-start.sh
ok "OK"
echo

heading "Test 100: Checking health via HTTP..."
$MPDIR/test/t100-check-health.sh
ok "Health check passed"
echo
