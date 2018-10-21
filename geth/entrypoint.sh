#!/bin/bash

geth --datadir "data" --nodiscover --networkid 8798798 --verbosity 6 --rpc --rpcaddr "0.0.0.0" --rpcport 8545 --rpcapi admin,web3,eth,personal,miner,net,txpool,debug --rpccorsdomain "http://localhost:8000"
