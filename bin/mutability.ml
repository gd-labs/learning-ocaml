(** Exercise: mutable fields. *)
type student =
{ name: string
; mutable gpa: float }

let () = 
  let alice = {name = "Alice"; gpa = 3.7} in
  alice.gpa <- 4.0
;;

(** Exercise: refs. *)
let bool_ref = ref false

let int_list_ref = ref [1; 2; 3]

let int_ref_list = [ref 1; ref 2; ref 3]

(** Exercise: inc fun. *)
let inc = ref (fun x -> x + 1)

(** Exercise: addition assignment. *)
let ( +:= ) x y =
  x := !x + y
;;

(** Exercise: physical equality. *)
let x = ref 0
let y = x
let z = ref 0

(** Exercise: norm. *)
type vector = float array

let norm v =
  Float.sqrt (Array.fold ~init:0. v ~f:(fun acc x -> acc +. x ** 2.))
;;

(** Exercise: normalize. *)
let normalize v =
  let n = norm v in
  Array.iteri v ~f:(fun i x -> v.(i) <- x /. n)
;;

(** Exercise: norm loop. *)
let norm_loop v =
  let n = ref 0. in
  for i = 0 to Array.length v - 1 do
    n := !n +. v.(i) ** 2.
  done;
  Float.sqrt !n
;;

(** Exercise: normalize loop. *)
let normalize_loop v =
  let n = norm_loop v in
  for i = 0 to Array.length v - 1 do
    v.(i) <- v.(i) /. n
  done;
;;

(** Exercise: init matrix. *)
let init_matrix n o ~f =
  Array.init n ~f:(fun i -> Array.init o ~f:(fun j -> f i j))
;;