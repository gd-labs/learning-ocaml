(** Exercise: mutable fields. *)
type student =
{ name: string
; mutable gpa: float }

let () = 
  let alice = {name = "Alice"; gpa = 3.7} in
  alice.gpa <- 4.0

(** Exercise: refs. *)
let bool_ref = ref false

let int_list_ref = ref [1; 2; 3]

let int_ref_list = [ref 1; ref 2; ref 3]

(** Exercise: inc fun. *)
let inc = ref (fun x -> x + 1)