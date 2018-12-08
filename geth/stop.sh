#!/bin/sh

name="$(cat ./docker_name)"

running_dockers="$(docker ps --format '{{.Names}}')"

running_name="$(echo ${running_dockers} | grep ${name})"

running="$(echo -n ${running_name} | grep -c "")"

if [ ${running} -eq 1 ]; then
    echo "Stopping ${running_name}"
    docker stop ${running_name}
elif [ ${running} -gt 1 ]; then
    echo "More than one ${name} image running. Currently unsupported. Exiting."
elif [ ${running} -lt 1 ]; then
    echo "No ${name} image running. Exiting."
fi
