#!/bin/sh


name="$(cat ./docker_name)"

running_dockers="$(docker ps --format '{{.Names}}')"

running_name="$(echo ${running_dockers} | grep ${name})"

running="$(echo -n ${running_name} | grep -c "")"

fix_docker() {
sleep 1
ps -ef | grep 'docker exec -it' | grep -v grep | awk '{ print $2}' | xargs kill -SIGWINCH
}

if [ ${running} -eq 1 ]; then
    echo "Executing bash in ${running_name}"
    fix_docker & docker exec -it --env COLUMNS=$COLUMNS --env LINES=$LINES ${running_name} bash
elif [ ${running} -gt 1 ]; then
    echo "More than one ${name} image running. Currently unsupported. Exiting."
elif [ ${running} -lt 1 ]; then
    echo "No ${name} image running. Exiting."
fi
