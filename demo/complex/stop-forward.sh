#!/bin/bash
ps -ef |grep forward |grep kubectl|cut -b 9-15|xargs kill -9
