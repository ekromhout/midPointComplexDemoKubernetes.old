source ../../library.bash

execute_gsh complex_grouper_daemon_1 add-ref-groups.gsh

#docker cp add-ref-groups.gsh complex_grouper_daemon_1:/tmp/
#docker exec complex_grouper_daemon_1 bash -c "/opt/grouper/grouper.apiBinary/bin/gsh /tmp/add-ref-groups.gsh"
