(** Exercise: list expressions *)
let lst = [1; 2; 3; 4; 5]
let lst = 1 :: 2 :: 3 :: 4 :: 5 :: []
let lst = [1] @ [2; 3; 4] @ [5]

(** Exercise: product *)
let rec product lst =
  match lst with
  | [] -> 1
  | h :: t -> h * product t
;;

let product_tr lst =
  let rec product_acc lst acc =
    match lst with
    | [] -> acc
    | h :: t -> product_acc t (h * acc) in
  product_acc lst 1
;;

(** Exercise: concat *)
let rec concat lst =
  match lst with
  | [] -> ""
  | h :: t -> h ^ concat t
;;

let concat_tr lst =
  let rec concat_acc lst acc =
    match lst with
    | [] -> acc
    | h :: t -> concat_acc t (acc ^ h) in
  concat_acc lst ""
;;

(** Exercise: patterns *)
let bigred lst =
  match lst with
  | [] -> false
  | h :: _ -> h = "bigred"
;;

let two_or_four lst =
  match lst with
  | _ :: _ :: [] -> true
  | _ :: _ :: _ :: _ :: [] -> true
  | _ -> false
;;

let two_equal lst =
  match lst with
  | a :: b :: _ -> a = b
  | _ -> false

(** Exercise: library *)
let fifth lst =
  if List.length lst < 5 then 0
  else List.nth lst 4

let sort_desc lst =
  lst |> List.sort Stdlib.compare |> List.rev

(** Exercise library puzzle *)
let get_last lst =
  lst |> List.rev |> List.hd

let get_zeros lst =
  lst |> List.mem 0

let get_zeros lst =
  lst |> List.exists (fun x -> x = 0)
;;

(** Exercise: take drop *)
let rec take n lst =
  if n = 0 then []
  else
    match lst with
    | [] -> []
    | x :: xs -> x :: take (n - 1) xs
;;

let rec drop n lst =
  if n = 0 then lst
  else
    match lst with
    | [] -> []
    | _ :: xs -> drop (n - 1) xs
;;

(** Exercise: take drop tail *)
let rec take_tr n lst acc =
  if n = 0 then acc
  else
    match lst with
    | [] -> acc
    | x :: xs -> take_tr (n - 1) xs (x :: acc)
;;

(** Exercise: unimodal *)
let rec is_mon_dec lst =
  match lst with
  | [] | [_] -> true
  | h :: (h2 :: t) -> h >= h2 && is_mon_dec t
;;

let rec is_mon_then_dec = function
  | [] | [_] -> true
  | h :: (h2 :: t) as lst ->
      if h <= h2 then is_mon_then_dec t
      else is_mon_dec lst
;;

let is_unimodal lst =
  is_mon_then_dec lst
;;

(** Exercise: powerset *)
let () = ()

(** Exercise: print int list rec *)
let rec print_int_list = function
  | [] -> ()
  | x :: xs -> print_endline (string_of_int x); print_int_list xs
;;

(** Exercise: print int list iter *)
let print_int_list' lst =
  lst |> List.iter (fun x -> print_endline (string_of_int x))
;;

(** Exercise: student *)
type student =
  {first_name: string; last_name: string; gpa: float}

let foo = {first_name = "bar"; last_name = "baz"; gpa = 4.0};;

let student_name student = 
  student.first_name, student.last_name 
;;

let new_student first_name last_name gpa =
  {first_name; last_name; gpa}
;;

(** Exercise: pokerecord *)
type poketype = Normal | Fire | Water

type pokemon =
  {name: string; hp: int; ptype: poketype}

let charizard = {name = "Charizard"; hp = 78; ptype = Fire};;

let squirtle = {name = "Squirtle"; hp = 44; ptype = Water};;

(** Exercise: safe hd and tl *)
let safe_hd = function
  | [] -> None
  | x :: _ -> Some x
;;

let safe_tl = function
  | [] -> None
  | _ :: t -> Some t
;;

(** Exercise: pokefun *)
let rec max_hp lst =
  match lst with
  | [] -> None
  | h :: t -> (
    match max_hp t with
    | None -> Some h
    | Some h2 -> Some (if h.hp >= h2.hp then h else h2)
  )
;;

(** Exercise: date before *)
type date = int * int * int

let is_before date1 date2 =
  let (y1, m1, d1) = date1 in
  let (y2, m2, d2) = date2 in
  y1 < y2 || (y1 = y2 && m1 < m2) || (m1 = m2 && d1 < d2)
;;

(** Exercise: earliest date *)
let rec earliest_date lst =
  match lst with
  | [] -> None
  | h :: t -> (
    match earliest_date t with
    | None -> Some h
    | Some h2 -> Some (if (is_before h h2) then h else h2)
  )
;;

(** Exercise: assoc list *)
let insert k v lst =
  (k, v) :: lst
;;

let rec lookup k = function
  | [] -> None
  | (k', v) :: t -> if k = k' then Some v else lookup k t
;;

let lst = (insert 1 "one" (insert 2 "two" (insert 2 "tree" [])));;
let two = lookup 2
let four = lookup 4

(** Exercise: cards *)
type suit = Clubs | Hearts | Diamonds | Spades
type rank = Number of int

type card = { rank: rank; suit: suit }

let () =
  let ace = {rank = Number 1; suit = Clubs} in
  let queen = {rank = Number 12; suit = Hearts} in
  let two = {rank = Number 2; suit = Diamonds} in
  let seven = {rank = Number 7; suit = Spades} in
  ()
;;

(** Exercise: matching *)
let p1: int option list = [None; Some 6]
let p2: int option list = [Some 5; None]
let p3: int option list = [None; None]
let p4: int option list = [Some 1]
let p5: int option list = [None]

(** Exercise: quadrant *)
type quad = I | II | III | IV
type sign = Neg | Zero | Pos

let sign (x: int): sign =
  if x < 0 then Neg
  else if x = 0 then Zero
  else Pos

let quadrant: int * int -> quad option = fun (x, y) ->
  match sign x, sign y with
  | Pos, Pos -> Some I
  | Neg, Pos -> Some II
  | Neg, Neg -> Some III
  | Pos, Neg -> Some IV
  | _ -> None
;;

(** Exercise: quadrant when *)
let quadrant_when: int * int -> quad option = function
  | x, y when x > 0 && y > 0 -> Some I
  | x, y when x < 0 && y > 0 -> Some II
  | x, y when x < 0 && y < 0 -> Some III
  | x, y when x > 0 && y < 0 -> Some IV
  | _ -> None
;;

(** Exercise: depth *)
type 'a tree = Leaf | Node of 'a * 'a tree * 'a tree;;

let rec depth tree =
  match tree with
  | Leaf -> 0
  | Node (_, left, right) ->
      1 + max (depth left) (depth right)
;;

(** Exercise: shape *)
let rec same_shape t1 t2 =
  match t1, t2 with
  | Leaf, Leaf -> true
  | Node (_, l1, r1), Node (_, l2, r2) ->
      (same_shape l1 l2) && (same_shape r1 r2)
  | _ -> false
;;

(** Exercise: list max exn *)
let rec list_max_helper h t =
  match t with
  | [] -> h
  | x :: xs -> list_max_helper (max h x) xs
;;

let list_max lst =
  match lst with
  | [] -> raise (Failure "list_max")
  | h :: t -> list_max_helper h t
;;

(** Exercise: list max exn string *)
let list_max_string lst =
  try string_of_int (list_max lst) with
  | Failure _ -> "empty"
;;