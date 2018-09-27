#!/usr/bin/env bats

load ../common

@test "Dummy test 1" {
    [ "a" = "a" ]
}

#@test "MariaDB service available" {
#  docker run -i $maintainer/$imagename find /usr/lib/systemd/system/mariadb.service
#}
#
#@test "MariaDB first run consumes tmpfile" {
##2  result="$(docker run -i $maintainer/$imagename find /tmp/firsttimerunning)"
#  [ "$result" != '' ]
#}

