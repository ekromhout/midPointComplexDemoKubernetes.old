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

@test "040 Check Shibboleth redirection (/midpoint)" {
    status="$(curl -k --write-out %{http_code} --silent --output /dev/null https://localhost:8443/midpoint)"
    [ "$status" -eq 302 ]
}

@test "041 Check Shibboleth redirection (/midpoint/)" {
    status="$(curl -k --write-out %{http_code} --silent --output /dev/null https://localhost:8443/midpoint/)"
    [ "$status" -eq 302 ]
}

@test "042 Check Shibboleth redirection (/midpoint/login)" {
    status="$(curl -k --write-out %{http_code} --silent --output /dev/null https://localhost:8443/midpoint/login)"
    [ "$status" -eq 302 ]
}

@test "043 Check Shibboleth redirection (/midpoint/something)" {
    status="$(curl -k --write-out %{http_code} --silent --output /dev/null https://localhost:8443/midpoint/something)"
    [ "$status" -eq 302 ]
}

@test "044 Check SOAP without Shibboleth redirection (/midpoint/ws/)" {
    status="$(curl -k --write-out %{http_code} --silent --output /dev/null https://localhost:8443/midpoint/ws/)"
    [ "$status" -eq 200 ]
}

@test "045 Check SOAP without Shibboleth redirection (/midpoint/model/)" {
    status="$(curl -k --write-out %{http_code} --silent --output /dev/null https://localhost:8443/midpoint/model/)"
    [ "$status" -eq 200 ]
}

@test "999 Clean up" {
    cd ../simple ; docker-compose down -v ; true
    docker-compose down -v
}
