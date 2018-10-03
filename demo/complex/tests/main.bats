#!/usr/bin/env bats

load ../../../common
load ../../../library

@test "000 Cleanup before running the tests" {
    (cd ../simple ; docker-compose down -v)
    (cd ../shibboleth ; docker-compose down -v)
    (cd ../postgresql ; docker-compose down -v)
    docker-compose down -v
}

@test "010 Initialize and start the composition" {
    docker ps -a >> /tmp/log
    docker ps
    ! (docker ps | grep -E "shibboleth_(idp|directory)_1|(complex|simple|shibboleth|postgresql)_(midpoint_server|midpoint_data)_1")
    cp tests/resources/sql/* sources/container_files/seed-data/
    docker-compose up -d --build
}

@test "020 Wait until components are started" {
    touch $BATS_TMPDIR/not-started
    wait_for_midpoint_start complex_midpoint_server_1 complex_midpoint_data_1
    wait_for_shibboleth_idp_start complex_idp_1
    wait_for_grouper_ui_start complex_grouper_ui_1
    rm $BATS_TMPDIR/not-started
}

@test "040 Check midPoint health" {
    if [ -e $BATS_TMPDIR/not-started ]; then skip 'not started'; fi
    check_health
}

@test "050 Check Shibboleth IDP health" {
    if [ -e $BATS_TMPDIR/not-started ]; then skip 'not started'; fi
    check_health_shibboleth_idp
}

@test "060 Check Grouper health" {
    if [ -e $BATS_TMPDIR/not-started ]; then skip 'not started'; fi
    skip TODO
}

@test "100 Get 'administrator'" {
    if [ -e $BATS_TMPDIR/not-started ]; then skip 'not started'; fi
    check_health
    get_and_check_object users 00000000-0000-0000-0000-000000000002 administrator
}

@test "110 And and get 'test110'" {
    if [ -e $BATS_TMPDIR/not-started ]; then skip 'not started'; fi
    check_health
    echo "<user><name>test110</name></user>" >/tmp/test110.xml
    add_object users /tmp/test110.xml
    rm /tmp/test110.xml
    search_and_check_object users test110
    delete_object_by_name users test110
}

@test "200 Upload objects" {
    if [ -e $BATS_TMPDIR/not-started ]; then skip 'not started'; fi
    check_health
    pwd >&2
    ./upload-objects

    search_and_check_object objectTemplates template-org-course
    search_and_check_object objectTemplates template-org-department
    search_and_check_object objectTemplates template-role-affiliation
    search_and_check_object objectTemplates template-role-generic-group
    
    search_and_check_object orgs courses
    search_and_check_object orgs departments

    search_and_check_object resources "OpenLDAP (directory)"
    search_and_check_object resources "Grouper SQL/MQ"
    search_and_check_object resources "SQL SIS courses (sources)"
    search_and_check_object resources "SQL SIS persons (sources)"

    search_and_check_object roles metarole-affiliation
    search_and_check_object roles metarole-course
    search_and_check_object roles metarole-department 
    search_and_check_object roles metarole-generic-group
    search_and_check_object roles role-grouper-sysadmin
    search_and_check_object roles role-ldap-basic
}

@test "210 Test resource" {
    if [ -e $BATS_TMPDIR/not-started ]; then skip 'not started'; fi
    test_resource 0a37121f-d515-4a23-9b6d-554c5ef61272
    test_resource 6dcb84f5-bf82-4931-9072-fbdf87f96442
    test_resource 13660d60-071b-4596-9aa1-5efcd1256c04
    test_resource 4d70a0da-02dd-41cf-b0a1-00e75d3eaa15
}

@test "220 Import SIS_PERSONS" {
    if [ -e $BATS_TMPDIR/not-started ]; then skip 'not started'; fi

    add_object tasks midpoint-objects-manual/tasks/task-import-sis-persons.xml
    search_and_check_object tasks "Import from SIS persons"
    wait_for_task_completion 22c2a3d0-0961-4255-9eec-c550a79aeaaa 6 10
    assert_task_success 22c2a3d0-0961-4255-9eec-c550a79aeaaa

    search_and_check_object users jsmith
    search_and_check_object users banderson
    search_and_check_object users kwhite
    search_and_check_object users whenderson
    search_and_check_object users ddavis
    search_and_check_object users cmorrison
    search_and_check_object users danderson
    search_and_check_object users amorrison
    search_and_check_object users wprice
    search_and_check_object users mroberts

    check_ldap_account_by_user_name jsmith complex_directory_1
    check_ldap_account_by_user_name banderson complex_directory_1
    check_ldap_account_by_user_name kwhite complex_directory_1
    check_ldap_account_by_user_name whenderson complex_directory_1
    check_ldap_account_by_user_name ddavis complex_directory_1
    check_ldap_account_by_user_name cmorrison complex_directory_1
    check_ldap_account_by_user_name danderson complex_directory_1
    check_ldap_account_by_user_name amorrison complex_directory_1
    check_ldap_account_by_user_name wprice complex_directory_1
    check_ldap_account_by_user_name mroberts complex_directory_1
    # TODO check assignments etc
}

@test "230 Check 'TestUser230' in Midpoint and LDAP" {
    if [ -e $BATS_TMPDIR/not-started ]; then skip 'not started'; fi
    check_health
    echo "<user><name>TestUser230</name><fullName>Test User230</fullName><givenName>Test</givenName><familyName>User230</familyName><credentials><password><value><clearValue>password</clearValue></value></password></credentials></user>" >/tmp/testuser230.xml
    add_object users /tmp/testuser230.xml
    rm /tmp/testuser230.xml
    search_and_check_object users TestUser230

    execute_bulk_action tests/resources/bulk-action/recom-role-grouper-sysadmin.xml
    execute_bulk_action tests/resources/bulk-action/assign-role-grouper-sysadmin-to-test-user.xml

    check_ldap_account_by_user_name TestUser230 complex_directory_1
    check_of_ldap_membership TestUser230 sysadmingroup complex_directory_1
    
    delete_object_by_name users TestUser230
}


@test "999 Clean up" {
    docker-compose down -v
}
