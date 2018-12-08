################################################################################
FROM ethereum/solc:stable as solc_container

################################################################################
FROM ocaml/opam2:ubuntu

##### Copy solc
copy --from=solc_container /usr/bin/solc /usr/bin

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

##### Prepare script to run
# Copy startup script and make it executable
COPY --chown=opam:opam ./entrypoint.sh $HOME
RUN chmod +x $HOME/entrypoint.sh

##### Copy writer_secret from git
COPY --chown=opam:opam ./writer_secret $HOME

##### Start everything
ENTRYPOINT ["/home/opam/entrypoint.sh"]