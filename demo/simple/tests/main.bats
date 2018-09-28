#!/usr/bin/env bats

load ../../../common
load ../../../library

@test "000 Initialize and start midPoint" {
    run docker-compose down -v
    docker-compose up -d
    wait_for_midpoint_start simple_midpoint-server_1
}

@test "010 Check health" {
    check_health
}

@test "100 Get 'administrator'" {
    check_health
    get_and_check_object users 00000000-0000-0000-0000-000000000002 administrator
}

@test "110 And and get 'test110'" {
    check_health
    echo "<user><name>test110</name></user>" >/tmp/test110.xml
    add_object users /tmp/test110.xml
    rm /tmp/test110.xml
    search_and_check_object users test110
}

@test "300 Check repository preserved between restarts" {
    check_health

    echo "Creating user test300 and checking its existence"
    echo "<user><name>test300</name></user>" >/tmp/test300.xml
    add_object users /tmp/test300.xml
    rm /tmp/test300.xml
    search_and_check_object users test300

    echo "Bringing the containers down"
    docker-compose down

    echo "Re-creating the containers"
    docker-compose up --no-start
    docker-compose start
    wait_for_midpoint_start simple_midpoint-server_1

    echo "Searching for the user again"
    search_and_check_object users test300
}

@test "999 Clean up" {
    docker-compose down -v
}
