#!/bin/sh

name="$(cat ./docker_name)"

running_dockers="$(docker ps --format '{{.Names}}')"

running_name="$(echo ${running_dockers} | grep ${name})"

running="$(echo -n ${running_name} | grep -c "")"

if [ ${running} -eq 1 ]; then
    echo "Commiting ${running_mvp_geths}"
    docker commit ${running_name} | sed 's/sha256://' > latest_commit
elif [ ${running} -gt 1 ]; then 
    echo "More than one ${name} image running. Currently unsupported. Exiting."
elif [ ${running} -lt 1 ]; then
    echo "No ${name} image running. Exiting."
fi
