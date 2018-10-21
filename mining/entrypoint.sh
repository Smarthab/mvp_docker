#!/bin/bash

eval $(opam env)

cd $HOME/gethscript

dune exec ./gethscript.exe -- --uri=$1 --secret=$HOME/writer_secret
