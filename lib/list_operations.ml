(** Different ways of implementing the map function. *)
let rec map f = function
  | [] -> []
  | h :: t -> f h :: map f t

let rec map f = function
  | [] -> []
  | h :: t -> (
    let h' = f h in h' :: map f t
  )
;;

let rec map_tr f acc = function
  | [] -> acc
  | h :: t -> map_tr f (acc @ [f h]) t
;;

let rec rev_map f acc = function
  | [] -> acc
  | h :: t -> rev_map f (f h :: acc) t
;;

(** Different ways of implementing the filter function. *)
let rec filter p = function
  | [] -> []
  | h :: t -> (
      if p h then h :: filter p t
      else filter p t
    )
;;

let rec filter_tr p acc = function
  | [] -> acc
  | h :: t -> (
      if p h then filter_tr p (h :: acc) t
      else filter_tr p acc t
    )
;;

let rec filter_tr p acc = function
  | [] -> List.rev acc (* Reversal implies another list traversion. *)
  | h :: t -> (
      if p h then filter_tr p (h :: acc) t
      else filter_tr p acc t
    )
;;

(** Different ways of implementing the fold function. *)
let rec fold_right f lst acc =
  match lst with
  | [] -> acc
  | h :: t -> (
      f h (fold_right f t acc)
  )
;;

let rec fold_left f acc = function
  | [] -> acc
  | h :: t -> fold_left f (f acc h) t
;;