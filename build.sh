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
SKIP_DOWNLOAD=0
while getopts "nh?" opt; do
    case $opt in
    n) SKIP_DOWNLOAD=1 ;;
    h | ?) echo "Options: -n skip download" ; exit 0 ;;
    *) echo "Unknown option: $opt" ; exit 1 ;;
    esac
done
if [ "$SKIP_DOWNLOAD" = "0" ]; then ./download-midpoint; fi
docker build --tag tier/midpoint:latest .
echo "---------------------------------------------------------------------------------------"
echo "The midPoint containers were successfully built. To start them, execute the following:"
echo ""
echo "(for simple demo)"
echo ""
echo "$ cd" $(normalize_path `pwd`/../demo/simple)
echo "$ docker-compose up"
echo ""
echo "(for complex demo)"
echo ""
echo "$ cd" $(normalize_path `pwd`/../demo/complex)
echo "$ docker-compose up --build"
