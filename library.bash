#!/bin/bash

#
# Contains common functions usable for midPoint system tests
#

# Waits until midPoint starts
function wait_for_midpoint_start () {
    CONTAINER_NAME=$1
    ATTEMPT=0
    MAX_ATTEMPTS=20
    DELAY=10

    until [[ $ATTEMPT = $MAX_ATTEMPTS ]]; do
        ATTEMPT=$((ATTEMPT+1))
        echo "Waiting $DELAY seconds for midPoint to start (attempt $ATTEMPT) ..."
        sleep $DELAY
        docker ps
        ( docker logs $CONTAINER_NAME 2>&1 | grep "INFO (com.evolveum.midpoint.web.boot.MidPointSpringApplication): Started MidPointSpringApplication in" ) && return 0
    done

    echo midPoint did not start in $(( $MAX_ATTEMPTS * $DELAY )) seconds in $CONTAINER_NAME
    echo "========== Container log =========="
    docker logs $CONTAINER_NAME 2>&1
    echo "========== End of the container log =========="
    return 1
}

# Checks the health of midPoint server
function check_health () {
    echo Checking health...
    (set -o pipefail ; curl -k -f https://localhost:8443/midpoint/actuator/health | tr -d '[:space:]' | grep -q "\"status\":\"UP\"")
    status=$?
    if [ $status -ne 0 ]; then
        echo Error: $status
        docker ps
        return 1
    else
        echo OK
        return 0
    fi
}

# Retrieves XML object and checks if the name matches
function get_and_check_object () {
    TYPE=$1
    OID=$2
    NAME=$3
    TMPFILE=$(mktemp /tmp/get.XXXXXX)
    echo tmp file is $TMPFILE
    curl -k --user administrator:5ecr3t -H "Content-Type: application/xml" -X GET "https://localhost:8443/midpoint/ws/rest/$TYPE/$OID" >$TMPFILE || (rm $TMPFILE ; return 1)
    if (grep -q "<name>$NAME</name>" <$TMPFILE); then
        echo "Object $TYPE/$OID '$NAME' is OK"
        rm $TMPFILE
        return 0
    else
        echo "Object $TYPE/$OID '$NAME' was not found or not retrieved correctly:"
        cat $TMPFILE
        rm $TMPFILE
        return 1
    fi
}

# Adds object from a given file
# TODO Returns the OID in OID variable
# it can be found in the following HTTP reader returned: Location: "https://localhost:8443/midpoint/ws/rest/users/85e62669-d36b-41ce-b4f1-1ffdd9f66262"
function add_object () {
    local TYPE=$1
    local FILE=$2
    echo "Adding to $TYPE from $FILE..."
    curl -k --user administrator:5ecr3t -H "Content-Type: application/xml" -X POST "https://localhost:8443/midpoint/ws/rest/$TYPE" -d @$FILE || return 1
    #TODO check the returned XML
    return 0
}

# Tries to find an object with a given name
# Results of the search are in the $SEARCH_RESULT_FILE
# TODO check if the result is valid (i.e. not an error) - return 1 if invalid, otherwise return 0 ("no objects" is considered OK here)
function search_objects_by_name () {
    TYPE=$1
    NAME=$2
    TMPFILE=$(mktemp /tmp/search.XXXXXX)

    curl -k --user administrator:5ecr3t -H "Content-Type: application/xml" -X POST "https://localhost:8443/midpoint/ws/rest/$TYPE/search" -d @- << EOF >$TMPFILE || (rm $TMPFILE ; return 1)
<q:query xmlns:q="http://prism.evolveum.com/xml/ns/public/query-3">
    <q:filter>
        <q:equal>
            <q:path>name</q:path>
            <q:value>$NAME</q:value>
        </q:equal>
    </q:filter>
</q:query>
EOF
    SEARCH_RESULT_FILE=$TMPFILE
    # TODO check validity of the file
    return 0
}

# Searches for object with a given name and verifies it was found
function search_and_check_object () {
    local TYPE=$1
    local NAME=$2
    search_objects_by_name $TYPE $NAME || return 1
    if (grep -q "<name>$NAME</name>" <$SEARCH_RESULT_FILE); then
        echo "Object $TYPE/'$NAME' is OK"
        rm $SEARCH_RESULT_FILE
        return 0
    else
        echo "Object $TYPE/'$NAME' was not found or not retrieved correctly:"
        cat $SEARCH_RESULT_FILE
        rm $SEARCH_RESULT_FILE
        return 1
    fi
}

# Tests a resource
function test_resource () {
    local OID=$1
    local TMPFILE=$(mktemp /tmp/test.resource.XXXXXX)
    local TMPFILE_ERR=$(mktemp /tmp/test.resource.err.XXXXXX)

    curl -k --user administrator:5ecr3t -H "Content-Type: application/xml" -X POST "https://localhost:8443/midpoint/ws/rest/resources/$OID/test" >$TMPFILE || (rm $TMPFILE $TMPFILE_ERR ; return 1)
    if [[ $(xmllint --xpath "*/status/text()" $TMPFILE) == "success" ]]; then
        echo "Resource $OID test succeeded"
        rm $TMPFILE
        return 0
    else
        echo "Resource $OID test failed"
        cat $TMPFILE
#        rm $TMPFILE
        return 1
    fi
}

function get_xpath () {
    echo ok
}
