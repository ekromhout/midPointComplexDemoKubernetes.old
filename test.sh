#!/bin/bash

. test/common.sh

trap 'exitcode=$? ; red "Exiting test.sh because of an error ($exitcode) occurred" ; exit $exitcode' ERR
echo "**************************************************************************************"
echo "***                            Testing midPoint image                              ***"
echo "**************************************************************************************"
echo
midpoint/test.sh
