#!/usr/bin/env bats

load ../../../common
load ../../../library

@test "000 Cleanup before running the tests" {
    cd ../simple ; docker-compose down -v ; true
    run docker-compose down -v
}

@test "010 Initialize and start midPoint" {
    cd ../simple ; env AUTHENTICATION=shibboleth docker-compose up -d
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
    curl -k --write-out %{redirect_url} --silent --output /dev/null https://localhost:8443/midpoint | grep 'https:\/\/localhost:4443\/idp\/profile\/SAML2\/Redirect'
}

@test "041 Check Shibboleth redirection (/midpoint/)" {
    curl -k --write-out %{redirect_url} --silent --output /dev/null https://localhost:8443/midpoint/ | grep 'https:\/\/localhost:4443\/idp\/profile\/SAML2\/Redirect'
}

@test "042 Check Shibboleth redirection (/midpoint/login)" {
    curl -k --write-out %{redirect_url} --silent --output /dev/null https://localhost:8443/midpoint/login | grep 'https:\/\/localhost:4443\/idp\/profile\/SAML2\/Redirect'
}

@test "043 Check Shibboleth redirection (/midpoint/something)" {
    curl -k --write-out %{redirect_url} --silent --output /dev/null https://localhost:8443/midpoint/something | grep 'https:\/\/localhost:4443\/idp\/profile\/SAML2\/Redirect'
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
