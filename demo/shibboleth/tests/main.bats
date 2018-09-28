#!/usr/bin/env bats

load ../../../common
load ../../../library

@test "000 Cleanup before running the tests" {
    cd ../simple ; docker-compose down -v ; true
    run docker-compose down -v
}

@test "010 Initialize and start midPoint" {
    cd ../simple ; docker-compose up -d
    wait_for_midpoint_start simple_midpoint-server_1
}

@test "020 Initialize and start Shibboleth" {
    docker-compose up -d
    # TODO implement wait_for_shibboleth_start
    sleep 60
}

@test "030 Check health" {
    check_health
}

# TODO check that e.g. accessing some URLs results in shibboleth redirection (check login page, some REST calls etc)

@test "999 Clean up" {
    cd ../simple ; docker-compose down -v ; true
    docker-compose down -v
}
