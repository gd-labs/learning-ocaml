(** Exercise: hashtbl usage. *)
let tuples i j =
  let rec iter i j l =
    if i > j then l
    else iter (i + 1) j ((i, string_of_int i) :: l)
  in
  iter i j []
;;

let tab = Hashtbl.create 16

let () = List.iter (fun (k, v) -> Hashtbl.add tab k v) (tuples 1 31)

let () = assert (Hashtbl.find tab 4 = "4")

let () = assert ((try Hashtbl.find tab 50 with Not_found -> "") = "")