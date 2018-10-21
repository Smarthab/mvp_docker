# install geth
FROM ubuntu:18.04 as geth_builder

RUN echo `pwd`
RUN apt-get update
RUN apt-get -y install make m4 gcc golang git
RUN git clone https://github.com/ethereum/go-ethereum
RUN cd /go-ethereum && make geth

# run geth
FROM ocaml/opam2:ubuntu

# Install prequired libraries
RUN opam switch 4.06
RUN opam depext jbuilder dune lwt conf-libsodium cryptokit zarith hex bitstring lwt yojson ocamlnet
RUN opam install jbuilder dune lwt batteries sodium cryptokit zarith hex bitstring lwt yojson lwt_ppx ocamlnet ppx_deriving
RUN sudo apt-get update
RUN sudo apt-get -y install libssh-dev

# Install ssh-client

RUN cd $HOME && git clone https://github.com/igarnier/ssh-client
RUN eval $(opam env) && cd $HOME/ssh-client && jbuilder build && jbuilder install

# Install ocaml-geth

RUN cd $HOME && git clone https://github.com/igarnier/ocaml-geth
RUN eval $(opam env) && cd $HOME/ocaml-geth && jbuilder build && jbuilder install

# Run geth

# Pull Geth into a second stage
COPY --from=geth_builder /go-ethereum/build/bin/geth /usr/local/bin/
EXPOSE 8545 8546 30303 30303/udp

COPY --chown=opam:opam ./genesis.json $HOME

# Prepare Geth to run in /home/opam
RUN cd $HOME && geth --datadir data init "genesis.json"

COPY --chown=opam:opam ./entrypoint.sh $HOME
RUN chmod +x $HOME/entrypoint.sh
RUN ls -la $HOME/entrypoint.sh
ENTRYPOINT ["/home/opam/entrypoint.sh"]