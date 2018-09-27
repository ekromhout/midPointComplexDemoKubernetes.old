#!/bin/bash

function normalize_path()
{
    # Remove all /./ sequences.
    local path=${1//\/.\//\/}

    # Remove dir/.. sequences.
    while [[ $path =~ ([^/][^/]*/\.\./) ]]
    do
        path=${path/${BASH_REMATCH[0]}/}
    done
    echo $path
}

cd "$(dirname "$0")"
./download-midpoint
docker build --tag tier/midpoint:latest midpoint-server
echo "---------------------------------------------------------------------------------------"
echo "The midPoint containers were successfully built. To start them, execute the following:"
echo ""
echo "(for standalone execution)"
echo ""
echo "$ cd" `pwd`
echo "$ docker-compose up --build"
echo ""
echo "(for complex demo)"
echo ""
echo "$ cd" $(normalize_path `pwd`/../demo/complex)
echo "$ docker-compose up --build"
