#!/bin/bash

BOLD='\033[1m'
UNDERLINE='\033[4m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
LCYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

function lred () {
  if [ -z "$NOCOLOR" ]; then
    echo -e "${LRED}$*${NC}"
  else
    echo "$*"
  fi
}

function lgreen () {
  if [ -z "$NOCOLOR" ]; then
    echo -e "${LGREEN}$*${NC}"
  else
    echo "$*"
  fi
}

function lcyan () {
  if [ -z "$NOCOLOR" ]; then
    echo -e "${LCYAN}$*${NC}"
  else
    echo "$*"
  fi
}

function yellow () {
  if [ -z "$NOCOLOR" ]; then
    echo -e "${YELLOW}$*${NC}"
  else
    echo "$*"
  fi
}

function boldUnderline () {
  if [ -z "$NOCOLOR" ]; then
    echo -e "${BOLD}${UNDERLINE}$*${NC}"
  else
    echo "$*"
  fi
}

function heading () {
  lcyan "=== $*"
}

function ok () {
  lgreen "==> $*"
}

function error () {
  lred "$*"
}

