################################################################################
# compile geth
FROM ubuntu:18.04 as geth_builder

RUN echo `pwd`
RUN apt-get update
RUN apt-get -y install make m4 gcc golang git
RUN git clone https://github.com/ethereum/go-ethereum
RUN cd /go-ethereum && make geth


################################################################################
FROM ocaml/opam2:ubuntu


##### Install prerequired libraries
RUN opam switch 4.06
RUN opam depext jbuilder dune lwt conf-libsodium cryptokit zarith hex bitstring yojson ocamlnet zmq dbm sqlite3
RUN opam install jbuilder dune lwt lwt_log lwt_ppx batteries sodium cryptokit zarith hex bitstring yojson ocamlnet ppx_deriving ppx_bin_prot ppx_inline_test zmq zmq-lwt cmdliner dbm sqlite3
RUN sudo apt-get update
RUN sudo apt-get -y install libssh-dev

##### Install ssh-client
RUN cd $HOME && git clone https://github.com/igarnier/ssh-client
RUN eval $(opam env) && cd $HOME/ssh-client && jbuilder build && jbuilder install

##### Install ocaml-geth
RUN cd $HOME && git clone https://github.com/igarnier/ocaml-geth
RUN eval $(opam env) && cd $HOME/ocaml-geth && jbuilder build && jbuilder install

##### Install huxiang
RUN cd $HOME && git clone https://github.com/igarnier/huxiang
RUN eval $(opam env) && cd $HOME/huxiang && dune build && dune install

##### Build the mvp
RUN cd $HOME && git clone https://github.com/Smarthab/mvp
run eval $(opam env) && cd $HOME/mvp && dune build producer.exe processor.exe

##### Build gethscript
# Copy gethscript from git
COPY --chown=opam:opam ./gethscript.ml $HOME/gethscript/
# Copy dune file from git
COPY --chown=opam:opam ./dune $HOME/gethscript/
# Perform build
RUN eval $(opam env) && cd $HOME/gethscript && dune build gethscript.exe

##### Prepare geth to run
# Pull Geth into this second stage
COPY --from=geth_builder /go-ethereum/build/bin/geth /usr/local/bin/
# Open some useful ports (/!\ be careful to not do this in prod /!\)
EXPOSE 8545 8546 30303 30303/udp
# Copy conf. file
COPY --chown=opam:opam ./genesis.json $HOME
# Prepare Geth to run in /home/opam
RUN cd $HOME && geth --datadir data init "genesis.json"
# Copy startup script and make it executable
COPY --chown=opam:opam ./entrypoint.sh $HOME
RUN chmod +x $HOME/entrypoint.sh

##### Copy writer_secret from git
COPY --chown=opam:opam ./writer_secret $HOME

##### Start everything
ENTRYPOINT ["/home/opam/entrypoint.sh"]