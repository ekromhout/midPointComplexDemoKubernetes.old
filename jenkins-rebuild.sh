#!/bin/bash

# Temporary workaround for docker/util not rebuilding the specific version of the image

# from destroy.sh (adapted)

source common.bash
source tag.bash

echo "Rebuilding $maintainer/$imagename:$tag..."

result=$(docker ps -a | grep $maintainer/$imagename:$tag)

if [ ! -z "$result" ]; then
  docker rm -f $(docker ps -a | grep $maintainer/$imagename:$tag | awk '{print $1}')
  docker rmi -f $maintainer/$imagename:$tag
fi

# from build.sh (adapted)

echo "Building new Docker image($maintainer/$imagename:$tag)"
docker build --rm -t $maintainer/$imagename:$tag --build-arg maintainer=$maintainer --build-arg imagename=$imagename .
