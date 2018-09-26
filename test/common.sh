#!/bin/bash

RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
NC='\033[0m'

function red () {
  echo -e ${RED}$*${NC}
}

function yellow () {
  echo -e ${YELLOW}$*${NC}
}

function green () {
  echo -e ${GREEN}$*${NC}
}
