#!/bin/bash

cd "$(dirname "$0")"
echo "Cleaning up containers and images in `pwd`"

docker-compose down -v
