################################################################################
# compile geth
FROM ubuntu:18.04 as geth_builder

RUN echo `pwd`
RUN apt-get update
RUN apt-get -y install make m4 gcc golang git
RUN git clone https://github.com/ethereum/go-ethereum
RUN cd /go-ethereum && make geth


################################################################################
FROM ubuntu:18.04

##### Prepare geth to run
# Pull Geth into this second stage
COPY --from=geth_builder /go-ethereum/build/bin/geth /usr/local/bin/
# Open some useful ports (/!\ be careful to not do this in prod /!\)
EXPOSE 8545 8546 30303 30303/udp
# Copy conf. file
COPY ./genesis.json /
# Prepare Geth to run
RUN geth --datadir data init "genesis.json"
# Copy startup script and make it executable
COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

##### Start everything
ENTRYPOINT ["/entrypoint.sh"]