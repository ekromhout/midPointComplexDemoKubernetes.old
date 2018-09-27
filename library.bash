#!/bin/bash

function wait_for_midpoint_start () {
    ATTEMPT=0
    MAX_ATTEMPTS=20
    DELAY=10

    until [[ $ATTEMPT = $MAX_ATTEMPTS ]]; do
        ATTEMPT=$((ATTEMPT+1))
        echo "Waiting $DELAY seconds for midPoint to start (attempt $ATTEMPT) ..."
        sleep $DELAY
        docker ps
        ( docker logs $1 2>&1 | grep "INFO (com.evolveum.midpoint.web.boot.MidPointSpringApplication): Started MidPointSpringApplication in" ) && return 0
    done

    echo midPoint did not start in $(( $MAX_ATTEMPTS * $DELAY )) seconds
    return 1
}
