#!/bin/bash
printenv | sed 's/^\(.*\)$/\1/g' | grep -E "^MP_VERSION" > /opt/tier/env.bash
printenv | sed 's/^\(.*\)$/\1/g' | grep -E "^TIER_RELEASE" >> /opt/tier/env.bash
printenv | sed 's/^\(.*\)$/\1/g' | grep -E "^TIER_MAINTAINER" >> /opt/tier/env.bash
