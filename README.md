# mvp_docker

This repo contains three Dockerfiles in directories geth/, mining/, mvp/.

INSTRUCTIONS

# 1. In a first terminal, build and run the geth Dockerfile
cd geth
make build
make run &

# 2. In another terminal, build and run the mining Dockerfile
cd mining
make build

# get the ip address of the Docker container running the geth node

docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mvp_geth

# this should return something like 172.17.0.2, henceforth denoted as w.x.y.z

# start mining

make run uri="http://w.x.y.z:8545"

# One should see something similar to this ater a several minutes:
# Created new account for writer: 0x622a61513d16c72f5295d2486037cfde72c474dd
# writer: 0
# writer: 0
# writer: 0
# writer: 0
# writer: 0
# writer: 45000000000000000000
# writer: 85000000000000000000
# writer: 105000000000000000000

# Here, the important information is the account which starts by "0x". It
# will be referred to in what follows by "0x..."

# 3. In a third terminal: build and run the dapp Dockerfile
cd mvp
make build
make run uri="http://w.x.y.z:8545" account="0x..."

# 4. Stop the miner
