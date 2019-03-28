#!/bin/bash

B='\033[1;33m'
N='\033[0m'

echo -e "${B} * Uploading objects...${N}"
$(dirname "$0")/upload-objects.sh

echo -e "${B} * Testing LDAP and SQL resources...${N}"
$(dirname "$0")/test-resources-1.sh

echo -e "${B} * Recomputing Grouper admin group and user object...${N}"
$(dirname "$0")/recompute.sh

echo -e "${B} * Waiting 120 seconds for changes to propagate to Grouper...${N}"
sleep 120

echo -e "${B} * Testing Grouper resource...${N}"
$(dirname "$0")/test-resource-grouper.sh

echo -e "${B} * Done${N}"
