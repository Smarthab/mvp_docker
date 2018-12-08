open Ocaml_geth

let mine uri address time =
  (try ignore (Rpc.Miner.set_ether_base ~uri ~address)
   with _ -> failwith "error in set_ether_base");
  Rpc.Miner.start ~uri ~thread_count:1;
  Unix.sleep time;
  Rpc.Miner.stop ~uri

(* Make some money iteratively for the writer and the reader *)

let main uri secret_phrase_file =
  let secret =
    let fd = open_in secret_phrase_file in
    let res = input_line fd in
    close_in fd;
    res
  in
  let writer = Rpc.Personal.new_account ~uri ~passphrase:secret in
  Printf.printf "Created new account for writer: %s\n%!" (Bitstr.Hex.show writer);
  while true do
    mine uri writer 30;
    (* miner reader 30 *)
    (* Print balance *)
    let writer_funds = Rpc.Eth.get_balance ~uri ~address:writer ~at_time:`latest
    in
    Printf.printf "writer: %s\n%!" 
      (Z.to_string writer_funds) 
  done

open Cmdliner

let uri =
  let doc = "Uri of Geth node. Defaults to http://localhost:8545" in
  Arg.(value & opt string "http://localhost:8545" & info ["uri"] ~doc)

let secret_phrase =
  let doc = "File containing secret phrase for generating public/secret key pair." in
  Arg.(required & opt (some string) None & info ["secret"] ~doc)

let producer_term =
  Term.(const main $ uri $ secret_phrase)

let info =
  let doc = "Schedules mining for the players" in
  let man = [
    `S Manpage.s_bugs;
    `P "Report bugs on https://github.com/SmartHab/mvp" ]
  in
  Term.info "gethscript" ~version:"%‌%VERSION%%" ~doc ~exits:Term.default_exits ~man

let () = Term.exit @@ Term.eval (producer_term, info)
