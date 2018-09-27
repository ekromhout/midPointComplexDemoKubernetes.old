#!/usr/bin/env bats

load ../../../common
load ../../../library

@test "000 Initialize and start midPoint" {
    run docker-compose down -v
    docker-compose up -d
    wait_for_midpoint_start simple_midpoint-server_1
}

@test "999 Clean up" {
    docker-compose down -v
}
