#!/bin/bash

(set -o pipefail ; curl -k -f http://localhost:443/midpoint/actuator/health | tr -d '[:space:]' | grep -q "\"status\":\"UP\"") || exit 1
