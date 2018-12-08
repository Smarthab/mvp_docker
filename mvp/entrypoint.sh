#!/bin/bash

eval $(opam env)

cd $HOME/mvp

echo "Deploying logger contract"

LOGGER=`dune exec ./deploy.exe -- --account=$1 --secret=$HOME/writer_secret --solidity=$HOME/mvp/logger.sol --uri=$2`

dune exec ./producer.exe -- --addr="tcp://127.0.0.1:5555" --secret=$HOME/writer_secret &

dune exec ./processor.exe --\
 --account=$1\
 --secret=$HOME/writer_secret\
 --listen="tcp://127.0.0.1:5555"\
 --contract="${LOGGER}"\
 --dbfile="packets"\
 --solidity="logger.sol"\
 --uri=$2&


