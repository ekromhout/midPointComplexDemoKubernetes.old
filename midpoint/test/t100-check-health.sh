#!/bin/bash

set -o pipefail ; curl -k -f https://localhost:8443/midpoint/actuator/health | tr -d '[:space:]' | grep -q "\"status\":\"UP\""
