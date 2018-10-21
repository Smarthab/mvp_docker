open Ocaml_geth

let uri = "http://localhost:8454"

let writer = Rpc.Personal.new_account ~uri ~passphrase:"writer"
let reader = Rpc.Personal.new_account ~uri ~passphrase:"reader"

let mine address time =
  assert (Rpc.Miner.set_ether_base ~uri writer);
  Rpc.Miner.start ~uri ~thread_count:1;
  Unix.sleep time;
  Rpcer.Miner.stop ~uri

(* Make some money iteratively for the writer and the reader *)

let _ =
  while true do
    mine writer 30;
    mine reader 30;
    (* Print balance *)
    let writer_funds = Rpc.Eth.get_balance ~uri ~address:writer ~at_time:`latest
    and reader_funds = Rpc.Eth.get_balance ~uri ~address:reader ~at_time:`latest
    in
    Printf.printf "writer: %s, reader:%s\n%!" 
      (Z.to_string writer_funds) 
      (Z.to_string reader_funds)
  done
