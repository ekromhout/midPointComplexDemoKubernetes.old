#!/bin/bash

#
# Contains common functions usable for midPoint system tests
#

# do not use from outside (ugly signature)
function generic_wait_for_log () {
    CONTAINER_NAME=$1
    MESSAGE="$2"
    WAITING_FOR="$3"
    FAILURE="$4"
    ADDITIONAL_CONTAINER_NAME=$5
    ATTEMPT=0
    MAX_ATTEMPTS=20
    DELAY=10

    until [[ $ATTEMPT = $MAX_ATTEMPTS ]]; do
        ATTEMPT=$((ATTEMPT+1))
        echo "Waiting $DELAY seconds for $WAITING_FOR (attempt $ATTEMPT) ..."
        sleep $DELAY
        docker ps
        ( docker logs $CONTAINER_NAME 2>&1 | grep "$MESSAGE" ) && return 0
    done

    echo "$FAILURE" in $(( $MAX_ATTEMPTS * $DELAY )) seconds in $CONTAINER_NAME
    echo "========== Container log =========="
    docker logs $CONTAINER_NAME 2>&1
    echo "========== End of the container log =========="
    if [ -n "ADDITIONAL_CONTAINER_NAME" ]; then
        echo "========== Container log ($ADDITIONAL_CONTAINER_NAME) =========="
        docker logs $ADDITIONAL_CONTAINER_NAME 2>&1
        echo "========== End of the container log ($DATABASE_CONTAINER_NAME) =========="
    fi
    return 1
}


function wait_for_log_message () {
    generic_wait_for_log $1 "$2" "log message" "log message has not appeared"
}

# Waits until midPoint starts
function wait_for_midpoint_start () {
    generic_wait_for_log $1 "INFO (com.evolveum.midpoint.web.boot.MidPointSpringApplication): Started MidPointSpringApplication in" "midPoint to start" "midPoint did not start" $2
}

# Waits until Shibboleth IDP starts ... TODO refactor using generic waiting function
function wait_for_shibboleth_idp_start () {
    CONTAINER_NAME=$1
    ATTEMPT=0
    MAX_ATTEMPTS=20
    DELAY=10

    until [[ $ATTEMPT = $MAX_ATTEMPTS ]]; do
        ATTEMPT=$((ATTEMPT+1))
        echo "Waiting $DELAY seconds for Shibboleth IDP to start (attempt $ATTEMPT) ..."
        sleep $DELAY
        docker ps
        ( docker logs $CONTAINER_NAME 2>&1 | grep "INFO:oejs.Server:main: Started" ) && return 0
    done

    echo Shibboleth IDP did not start in $(( $MAX_ATTEMPTS * $DELAY )) seconds in $CONTAINER_NAME
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

# Checks the health of Shibboleth IDP server
function check_health_shibboleth_idp () {
    echo Checking health of shibboleth idp...
    status="$(curl -k --write-out %{http_code} --silent --output /dev/null https://localhost:4443/idp/)"
    if [ $status -ne 200 ]; then
        echo Error: Http code of response is $status
        docker ps
        return 1
    else
        echo OK
        return 0
    fi
}


function get_object () {
    local TYPE=$1
    local OID=$2
    TMPFILE=$(mktemp /tmp/get.XXXXXX)
    echo tmp file is $TMPFILE
    curl -k --user administrator:5ecr3t -H "Content-Type: application/xml" -X GET "https://localhost:8443/midpoint/ws/rest/$TYPE/$OID" >$TMPFILE || (rm $TMPFILE ; return 1)
    return 0
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
    
    response=$(curl -k -sD - --silent --write-out "%{http_code}" --user administrator:5ecr3t -H "Content-Type: application/xml" -X POST "https://localhost:8443/midpoint/ws/rest/$TYPE" -d @$FILE)
    http_code=$(sed '$!d' <<<"$response")
    
    if [ "$http_code" -eq 201 ] || [ "$http_code" -eq 202 ]; then
        
	# get the real Location
    	location=$(grep -oP "Location: \K.*" <<<"$response")
	oid=$(sed 's/.*\///' <<<"$location")

        echo "Oid created object: $oid"
        return 0
    else
    	echo "Error code: $http_code"
    	if [ "$http_code" -eq 500 ]; then
            echo "Error message: Internal server error. Unexpected error occurred, if necessary please contact system administrator."
    	else
            error_message=$(grep 'message' <<<"$response" | head -1 | awk -F">" '{print $2}' | awk -F"<" '{print $1}')
            echo "Error message: $error_message"
    	fi
        return 1
    fi
    #curl -k --user administrator:5ecr3t -H "Content-Type: application/xml" -X POST "https://localhost:8443/midpoint/ws/rest/$TYPE" -d @$FILE || return 1
    #TODO check the returned XML
}

# Tries to find an object with a given name
# Results of the search are in the $SEARCH_RESULT_FILE
# TODO check if the result is valid (i.e. not an error) - return 1 if invalid, otherwise return 0 ("no objects" is considered OK here)
function search_objects_by_name () {
    TYPE=$1
    NAME="$2"
    TMPFILE=$(mktemp /tmp/search.XXXXXX)

    curl -k --write-out %{http_code}  --user administrator:5ecr3t -H "Content-Type: application/xml" -X POST "https://localhost:8443/midpoint/ws/rest/$TYPE/search" -d @- << EOF >$TMPFILE || (rm $TMPFILE ; return 1)
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
    
    http_code=$(sed '$!d' <<<"$(cat $SEARCH_RESULT_FILE)")

    sed -i '$ d' $SEARCH_RESULT_FILE
    cat $SEARCH_RESULT_FILE
    if [ "$http_code" -eq 200 ]; then
        return 0
    else
    	return 1
    fi
}

# Searches for object with a given name and verifies it was found
function search_and_check_object () {
    local TYPE=$1
    local NAME="$2"
    search_objects_by_name $TYPE "$NAME" || return 1
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

    curl -k --user administrator:5ecr3t -H "Content-Type: application/xml" -X POST "https://localhost:8443/midpoint/ws/rest/resources/$OID/test" >$TMPFILE || (rm $TMPFILE ; return 1)
    if [[ $(xmllint --xpath "/*/*[local-name()='status']/text()" $TMPFILE) == "success" ]]; then
        echo "Resource $OID test succeeded"
        rm $TMPFILE
        return 0
    else
        echo "Resource $OID test failed"
        cat $TMPFILE
        rm $TMPFILE
        return 1
    fi
}

function assert_task_success () {
    local OID=$1
    get_object tasks $OID
    TASK_STATUS=$(xmllint --xpath "/*/*[local-name()='resultStatus']/text()" $TMPFILE) || (echo "Couldn't extract task status from task $OID" ; cat $TMPFILE ; rm $TMPFILE ; return 1)
    if [[ $TASK_STATUS = "success" ]]; then
        echo "Task $OID status is OK"
        rm $TMPFILE
        return 0
    else
        echo "Task $OID status is not OK: $TASK_STATUS"
        cat $TMPFILE
        rm $TMPFILE
        return 1
    fi
}

function wait_for_task_completion () {
    local OID=$1
    sleep 60		# TODO
    return 0
}
