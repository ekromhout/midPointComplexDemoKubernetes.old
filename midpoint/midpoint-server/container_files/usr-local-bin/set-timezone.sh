#!/bin/bash

# JUST FOR TESTING - REMOVE BEFORE RELEASE

rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Bratislava /etc/localtime
date

