#!/bin/bash

eval $(opam env)

echo $PATH

cd /home/opam

geth --datadir "data" --nodiscover --networkid 8798798 --verbosity 6 --rpc --rpcaddr "0.0.0.0" --rpcport 8545 --rpcapi admin,web3,eth,personal,miner,net,txpool,debug --rpccorsdomain "http://localhost:8000"&

sleep 5

cd gethscript

dune exec ./gethscript.exe -- --secret=/home/opam/writer_secret
