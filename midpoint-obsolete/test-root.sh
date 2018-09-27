#!/bin/bash

. test/common.sh

trap 'exitcode=$? ; error "Exiting test.sh because of an error ($exitcode) occurred" ; exit $exitcode' ERR
yellow "**************************************************************************************"
yellow "***                            Testing midPoint image                              ***"
yellow "**************************************************************************************"
echo
midpoint/test.sh
demo/shibboleth/test.sh
echo
lgreen "**************************************************************************************"
lgreen "***                               All tests passed                                 ***"
lgreen "**************************************************************************************"
