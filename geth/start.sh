#!/bin/sh

name="$(cat ./docker_name)"

running_dockers="$(docker ps --format '{{.Names}}')"

running_name="$(echo ${running_dockers} | grep ${name})"

running="$(echo -n ${running_name} | grep -c "")"

if [ ${running} -gt 0 ]; then
    echo "${running_name} already running. Exiting."
else
    hash="$(cat ./latest_commit)"
    docker run --rm --name ${name} ${hash}
fi
