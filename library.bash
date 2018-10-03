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
    MAX_ATTEMPTS=40
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
    generic_wait_for_log $1 "INFO:oejs.Server:main: Started" "shibboleth idp to start" "shibboleth idp did not start" $2
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
    TMPFILE=$(mktemp /tmp/execbulkaction.XXXXXX)
    echo "Adding to $TYPE from $FILE..."
    
    curl -k -sD - --silent --write-out "%{http_code}" --user administrator:5ecr3t -H "Content-Type: application/xml" -X POST "https://localhost:8443/midpoint/ws/rest/$TYPE" -d @$FILE >$TMPFILE
     local HTTP_CODE=$(sed '$!d' $TMPFILE)
    
    if [ "$HTTP_CODE" -eq 201 ] || [ "$HTTP_CODE" -eq 202 ]; then
        
	# get the real Location
	OID=$(grep -oP "Location: \K.*" $TMPFILE | awk -F "$TYPE/" '{print $2}') || (echo "Couldn't extract oid from file:" ; cat $TMPFILE ; rm $TMPFILE; return 1)

        echo "Oid created object: $OID"
	rm $TMPFILE
        return 0
    else
    	echo "Error code: $HTTP_CODE"
    	if [ "$HTTP_CODE" -ge 500 ]; then
            echo "Error message: Internal server error. Unexpected error occurred, if necessary please contact system administrator."
    	else
	    local ERROR_MESSAGE=$(xmllint --xpath "/*/*[local-name()='error']/text()" $TMPFILE) || (echo "Couldn't extract error message from file:" ; cat $TMPFILE ; rm $TMPFILE; return 1)
            echo "Error message: $ERROR_MESSAGE"
    	fi
	rm $TMPFILE
        return 1
    fi
}

function execute_bulk_action () {
    local FILE=$1
    echo "Executing bulk action from $FILE..."
    TMPFILE=$(mktemp /tmp/execbulkaction.XXXXXX)    

    curl -k --silent --write-out "%{http_code}" --user administrator:5ecr3t -H "Content-Type: application/xml" -X POST "https://localhost:8443/midpoint/ws/rest/rpc/executeScript" -d @$FILE >$TMPFILE
    local HTTP_CODE=$(sed '$!d' $TMPFILE)
    sed -i '$ d' $TMPFILE

    if [ "$HTTP_CODE" -eq 200 ]; then
        
        local STATUS=$(xmllint --xpath "/*/*/*[local-name()='status']/text()" $TMPFILE) || (echo "Couldn't extract status from file:" ; cat $TMPFILE ; rm $TMPFILE; return 1)        
        if [ $STATUS = "success" ]; then
            local CONSOLE_OUTPUT=$(xmllint --xpath "/*/*/*[local-name()='consoleOutput']/text()" $TMPFILE) || (echo "Couldn't extract console output from file:" ; cat $TMPFILE ; rm $TMPFILE; return 1)
            echo "Console output: $CONSOLE_OUTPUT"
            rm $TMPFILE
            return 0
	else
            echo "Bulk action status is not OK: $STATUS"
            local CONSOLE_OUTPUT=$(xmllint --xpath "/*/*/*[local-name()='consoleOutput']/text()" $TMPFILE) || (echo "Couldn't extract console output from file:" ; cat $TMPFILE ; rm $TMPFILE; return 1)
 	    echo "Console output: $CONSOLE_OUTPUT"
	    rm $TMPFILE
            return 1
        fi

    else
        echo "Error code: $HTTP_CODE"
        if [ "$HTTP_CODE" -ge 500 ]; then
            echo "Error message: Internal server error. Unexpected error occurred, if necessary please contact system administrator."
        else
            local ERROR_MESSAGE=$(xmllint --xpath "/*/*[local-name()='error']/text()" $TMPFILE) || (echo "Couldn't extract error message from file:" ; cat $TMPFILE ; rm $TMPFILE; return 1)
	    echo "Error message: $ERROR_MESSAGE"
        fi
  	rm $TMPFILE
        return 1
    fi
}

function delete_object_by_name () {
    local TYPE=$1
    local NAME=$2
    search_objects_by_name users $NAME
    local OID=$(xmllint --xpath "/*/*[local-name()='object']/@oid" $SEARCH_RESULT_FILE | awk -F"\"" '{print $2}' ) || (echo "Couldn't extract oid from file:" ; cat $SEARCH_RESULT_FILE ; rm $SEARCH_RESULT_FILE; return 1)
    delete_object $TYPE $OID   
}

function delete_object () {
    local TYPE=$1
    local OID=$2
    echo "Deleting object with type $TYPE and oid $OID..."
    TMPFILE=$(mktemp /tmp/delete.XXXXXX)

    curl -k --silent --write-out "%{http_code}" --user administrator:5ecr3t -H "Content-Type: application/xml" -X DELETE "https://localhost:8443/midpoint/ws/rest/$TYPE/$OID" >$TMPFILE
    local HTTP_CODE=$(sed '$!d' $TMPFILE)
    sed -i '$ d' $TMPFILE

    if [ "$HTTP_CODE" -eq 204 ]; then
	
	echo "Object with type $TYPE and oid $OID was deleted"
        rm $TMPFILE
        return 0
    else
        echo "Error code: $HTTP_CODE"
        if [ "$HTTP_CODE" -ge 500 ]; then
            echo "Error message: Internal server error. Unexpected error occurred, if necessary please contact system administrator."
        else
            local ERROR_MESSAGE=$(xmllint --xpath "/*/*[local-name()='error']/text()" $TMPFILE) || (echo "Couldn't extract error message from file:" ; cat $TMPFILE ; rm $TMPFILE; return 1)
            echo "Error message: $ERROR_MESSAGE"
	fi
	rm $TMPFILE
        return 1
    fi
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
        rm $SEARCH_RESULT_FILE
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
    local ATTEMPT=0
    local MAX_ATTEMPTS=$2
    local DELAY=$3

    until [[ $ATTEMPT = $MAX_ATTEMPTS ]]; do
        ATTEMPT=$((ATTEMPT+1))
        echo "Waiting $DELAY seconds for task with oid $OID to finish (attempt $ATTEMPT) ..."
        sleep $DELAY
	get_object tasks $OID
        TASK_EXECUTION_STATUS=$(xmllint --xpath "/*/*[local-name()='executionStatus']/text()" $TMPFILE) || (echo "Couldn't extract task status from task $OID" ; cat $TMPFILE ; rm $TMPFILE ; return 1)
        if [[ $TASK_EXECUTION_STATUS = "suspended" ]] || [[ $TASK_EXECUTION_STATUS = "closed" ]]; then
    	    echo "Task $OID is finished"
        	rm $TMPFILE
        	return 0
        fi
    done
    rm $TMPFILE
    echo Task with $OID did not finish in $(( $MAX_ATTEMPTS * $DELAY )) seconds
    return 1
}


#search LDAP accout by uid
function search_ldap_object_by_filter () {
    local BASE_CONTEXT_FOR_SEARCH=$1
    local FILTER="$2"
    local LDAP_CONTAINER=$3
    TMPFILE=$(mktemp /tmp/ldapsearch.XXXXXX)

    docker exec $LDAP_CONTAINER ldapsearch -h localhost -p 389 -D "cn=Directory Manager" -w password -b "$BASE_CONTEXT_FOR_SEARCH" "($FILTER)" >$TMPFILE || (rm $TMPFILE ; return 1)
    LDAPSEARCH_RESULT_FILE=$TMPFILE  
    return 0
}

function check_ldap_account_by_user_name () {
    local NAME=$1
    local LDAP_CONTAINER=$2
    search_ldap_object_by_filter "ou=people,dc=internet2,dc=edu" "uid=$NAME" $LDAP_CONTAINER
    search_objects_by_name users $NAME
    
    local MP_FULL_NAME=$(xmllint --xpath "/*/*/*[local-name()='fullName']/text()" $SEARCH_RESULT_FILE) || (echo "Couldn't extract user fullName from file:" ; cat $SEARCH_RESULT_FILE ; rm $SEARCH_RESULT_FILE ; rm $LDAPSEARCH_RESULT_FILE ; return 1)
    local MP_GIVEN_NAME=$(xmllint --xpath "/*/*/*[local-name()='givenName']/text()" $SEARCH_RESULT_FILE) || (echo "Couldn't extract user givenName from file:" ; cat $SEARCH_RESULT_FILE ; rm $SEARCH_RESULT_FILE ; rm $LDAPSEARCH_RESULT_FILE ; return 1)
    local MP_FAMILY_NAME=$(xmllint --xpath "/*/*/*[local-name()='familyName']/text()" $SEARCH_RESULT_FILE) || (echo "Couldn't extract user familyName from file:" ; cat $SEARCH_RESULT_FILE ; rm $SEARCH_RESULT_FILE ; rm $LDAPSEARCH_RESULT_FILE ; return 1)    

    local LDAP_CN=$(grep -oP "cn: \K.*" $LDAPSEARCH_RESULT_FILE) || (echo "Couldn't extract user cn from file:" ; cat $LDAPSEARCH_RESULT_FILE ; rm $SEARCH_RESULT_FILE ; rm $LDAPSEARCH_RESULT_FILE ; return 1)
    local LDAP_GIVEN_NAME=$(grep -oP "givenName: \K.*" $LDAPSEARCH_RESULT_FILE) || (echo "Couldn't extract user givenName from file:" ; cat $LDAPSEARCH_RESULT_FILE ; rm $SEARCH_RESULT_FILE ; rm $LDAPSEARCH_RESULT_FILE ; return 1)
    local LDAP_SN=$(grep -oP "sn: \K.*" $LDAPSEARCH_RESULT_FILE) || (echo "Couldn't extract user sn from file:" ; cat $LDAPSEARCH_RESULT_FILE ; rm $SEARCH_RESULT_FILE ; rm $LDAPSEARCH_RESULT_FILE ; return 1)

    rm $SEARCH_RESULT_FILE
    rm $LDAPSEARCH_RESULT_FILE

    if [[ $MP_FULL_NAME = $LDAP_CN ]] && [[ $MP_GIVEN_NAME = $LDAP_GIVEN_NAME ]] && [[ $MP_FAMILY_NAME = $LDAP_SN ]]; then
	return 0
    fi
    
    echo "User in Midpoint and LDAP Account with uid $NAME are not same"
    return 1
}

function check_of_ldap_membership () {
    local NAME_OF_USER=$1
    local NAME_OF_GROUP=$2
    local LDAP_CONTAINER=$3
    search_ldap_object_by_filter "ou=people,dc=internet2,dc=edu" "uid=$NAME_OF_USER" $LDAP_CONTAINER

    local LDAP_ACCOUNT_DN=$(grep -oP "dn: \K.*" $LDAPSEARCH_RESULT_FILE) || (echo "Couldn't extract user dn from file:" ; cat $LDAPSEARCH_RESULT_FILE ; rm $LDAPSEARCH_RESULT_FILE ; return 1)
    
    search_ldap_object_by_filter "ou=groups,dc=internet2,dc=edu" "cn=$NAME_OF_GROUP" $LDAP_CONTAINER

    local LDAP_MEMBERS_DNS=$(grep -oP "uniqueMember: \K.*" $LDAPSEARCH_RESULT_FILE) || (echo "Couldn't extract user uniqueMember from file:" ; cat $LDAPSEARCH_RESULT_FILE ; rm $LDAPSEARCH_RESULT_FILE ; return 1)

    rm $LDAPSEARCH_RESULT_FILE

    if [[ $LDAP_MEMBERS_DNS =~ $LDAP_ACCOUNT_DN ]]; then
        return 0
    fi

    echo "LDAP Account with uid $NAME_OF_USER is not member of LDAP Group $NAME_OF_GROUP"
    return 1
}

