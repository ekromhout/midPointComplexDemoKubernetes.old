#!/usr/bin/env bats

load ../../../common
load ../../../library

@test "000 Cleanup before running the tests" {
#    skip
    cd ../shibboleth ; docker-compose down -v ; true
    run docker-compose down -v
}

@test "010 Initialize and start the composition" {
#    skip
    docker ps -a
    docker-compose up -d
    wait_for_midpoint_start complex_midpoint-server_1
# TODO wait for shibboleth, grouper-ui, (also something other?)
}

@test "010 Check midPoint health" {
    check_health
}

@test "020 Check Grouper health" {
    skip TODO
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
# TODO delete user after
}

@test "200 Upload objects" {
    check_health
    pwd >&2
    ./upload-objects
    search_and_check_object objectTemplates template-org-course
    search_and_check_object objectTemplates template-org-department
    search_and_check_object objectTemplates template-role-affiliation
    search_and_check_object objectTemplates template-role-generic-group
# TODO check other objects that were uploaded
}

@test "210 Test resource" {
    test_resource 0a37121f-d515-4a23-9b6d-554c5ef61272
    test_resource 6dcb84f5-bf82-4931-9072-fbdf87f96442
    test_resource 13660d60-071b-4596-9aa1-5efcd1256c04
    test_resource 4d70a0da-02dd-41cf-b0a1-00e75d3eaa15
}

@test "999 Clean up" {
    docker-compose down -v
}
