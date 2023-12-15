(** Exercise: repeat. *)
let rec repeat f n x =
  if n = 0 then 0 else repeat f (n - 1) (f x)
;;

(** Exercise: product. *)
let product_left lst = List.fold_left ( *. ) 1.0 lst;;

let product_right lst = List.fold_right ( *. ) lst 1.0;;

(** Exercise: sum_cube_odd. *)
let rec ( -- ) i j = if i > j then [] else i :: i + 1 -- j

let sum_cube_odd n =
  let lst = 0 -- n in
  let odd_lst = List.filter (fun x -> x mod 2 = 1) lst in
  let cube_lst = List.map (fun x -> x * x * x) odd_lst in
  let sum = List.fold_left ( + ) 0 cube_lst in
  sum
;;

(** Exercise: sum_cube_odd pipeline. *)
let sum_cube_odd n =
  0 -- n
  |> List.filter (fun x -> x mod 2 = 1)
  |> List.map (fun x -> x * x * x)
  |> List.fold_left ( + ) 0
;;

(** Exercise: exists. *)
let rec exists_rec p = function
  | [] -> false
  | h :: t -> p h || exists_rec p t
;;

let exists_fold p lst =
  lst |> List.fold_left (fun acc elt -> acc || p elt) false
;;

let exits_lib = List.exists;;

(** Exercise: account balance. *)
let rec account_balance amt = function
  | [] -> amt
  | h :: t -> account_balance (amt -. h) t
;;

let account_balance amt lst =
  amt -. (List.fold_left ( +. ) 0. lst)
;;

let account_balance amt lst =
  amt -. (List.fold_right ( +. ) lst 0.)
;;

(** Exercise: library uncurried. *)
let uncurried_append (lst, e) = List.append lst e;;

let uncurried_compare (c1, c2) = Char.compare c1 c2

let uncurried_max (e1, e2) = Stdlib.max e1 e2;;

(** Exercise: map composition. *)
let map_composition f g lst =
  List.map (fun x -> f (g x)) lst
;;

(** Exercise: more list fun. *)
let filter_length =
  List.filter (fun x -> String.length x > 3)
;;

let map_add =
  List.map (fun x -> x +. 1.0)
;;

let fold_sep strs sep =
  List.fold_right
    (fun acc str ->
      if str = "" then acc
      else acc ^ sep ^ str
    ) strs ""
;; 

let fold_sep strs sep =
  match strs with
  | [] -> ""
  | h :: t -> List.fold_left (fun acc s -> acc ^ sep ^ s) h t
;;

(** Exercise: assiciation list keys. *)
let rec keys lst =
  List.fold_right
    (fun (k, _) acc -> k :: List.filter (fun k' -> k <> k') acc)
    lst
    []
;;

let rec keys lst =
  List.fold_left
    (fun acc (k, _) -> if List.exists ((=) k) acc then acc else k :: acc)
    []
    lst
;;

let keys lst =
  lst
  |> List.map fst
  |> List.sort_uniq Stdlib.compare
;;

(** Exercise: valid matrix. *)
let is_valid_matrix mtx =
  let cols = List.length mtx in
  mtx
  |> List.fold_left (fun acc lst -> (cols = List.length lst) && acc) true
;;

(** Exercise: row vector add. *)
let add_row_vectors = List.map2 ( + );;

(** Exercise: matrix add. *)
let add_matrices = List.map2 add_row_vectors;; 