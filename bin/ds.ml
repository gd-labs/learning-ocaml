open Hashtbl

(** Exercise: hashtbl usage. *)
let tuples i j =
  let rec iter i j l =
    if i > j then l
    else iter (i + 1) j ((i, string_of_int i) :: l)
  in
  iter i j []
;;

let tab = create 16

let () = List.iter (fun (k, v) -> add tab k v) (tuples 1 31)

let () = assert (find tab 4 = "4")

let () = assert ((try find tab 50 with Not_found -> "") = "")

(** Exercise: hashtbl bindings. *)
let _bindings t =
  fold (fun k v acc -> (k, v) :: acc) t []
;;

(** Exercise: load factor. *)
let load_factor t =
  let ( /.. ) x y = float_of_int x /. float_of_int y in
  let s = stats t in
  s.num_bindings /.. s.num_buckets
;;

(** Exercise: functorial interface. *)
module StringHashtbl =
  Hashtbl.Make(struct
    type t = string

    let equal a b =
      String.lowercase_ascii a = String.lowercase_ascii b

    let hash s = Hashtbl.hash (String.lowercase_ascii s)
  end)
;;

(** Exercise: functorized BST. *)
module type Set = sig
  (** [elt] is the type of the set elements. *)
  type elt

  (** [t] is the type of sets whose elements have type [elt]. *)
  type t
  
  (** [empty] is the empty set. *)
  val empty : t

  (** [insert x s] is the set ${x} \union s$. *)
  val insert : elt -> t -> t

  (** [mem x s] is whether $x \in $s. *)
  val mem : elt -> t -> bool

  (** [of_list lst] is the smallest set containing all the elements of [lst]. *)
  val of_list : elt list -> t

  (** [elements s] is the list containing the same elements as [s]. *)
  val elements : t -> elt list
end

module type Ordered = sig
  type t

  val compare : t -> t -> int
end

module BstSet (Ord : Ordered) : Set = struct
  type elt = Ord.t

  type t = Leaf | Node of t * elt * t

  let empty = Leaf

  let rec mem x = function
    | Leaf -> false
    | Node (l, v, r) -> (
      match compare x v with
      | ord when ord < 0 -> mem x l
      | ord when ord > 0 -> mem x r
      | _ -> true
    )

  let rec insert x = function
    | Leaf -> Node (Leaf, x, Leaf)
    | Node (l, v, r) -> (
      match compare x v with
      | ord when ord < 0 -> Node (insert x l, v, r)
      | ord when ord > 0 -> Node (l, v, insert x r)
      | _ -> Node (l, x, r)
    )
  
  let of_list lst =
    List.fold_left (fun s x -> insert x s) empty lst

  let rec elements = function
    | Leaf -> []
    | Node (l, v, r) -> (elements l) @ [v] @ (elements r) 
end

(** Exercise: efficient traversal. *)
type 'a tree = Leaf | Node of 'a tree * 'a * 'a tree

let t =
  Node(Node(Node(Leaf, 1, Leaf), 2, Node(Leaf, 3, Leaf)),
  4,
  Node(Node(Leaf, 5, Leaf), 6, Node(Leaf, 7, Leaf)))

let preorder t =
  let rec pre_acc acc = function
    | Leaf -> acc
    | Node (l, v, r) -> v :: pre_acc (pre_acc acc r) l 
  in
  pre_acc [] t
;;

let inorder t =
  let rec in_acc acc = function
    | Leaf -> acc
    | Node (l, v, r) -> in_acc (v :: (in_acc acc r)) l
  in
  in_acc [] t
;;

let postorder t =
  let rec post_acc acc = function
    | Leaf -> acc
    | Node (l, v, r) -> post_acc (post_acc (v :: acc) r) l
  in
  post_acc [] t
;;

let () = assert (preorder t = [4;2;1;3;6;5;7])
let () = assert (inorder t = [1;2;3;4;5;6;7])
let () = assert (postorder t = [1;3;2;5;7;6;4])

(** Exercise: pow2. *)
type 'a sequence = Cons of 'a * (unit -> 'a sequence)

let rec make n =
  Cons (n, fun () -> make (n + 1))

let hd (Cons (h, _)) = h  

let tl (Cons (_, t)) = t ()

let take n s =
  let rec take_acc acc s = function
    | 0 -> acc
    | _ -> take_acc (hd s :: acc) (tl s) (n - 1)
  in
  take_acc [] s n
;;

let pow2 n =
  Cons (n, f () -> 2 * n)

(** Exercise: more sequences. *)
let evens =
  let evens_helper n =
    Cons (n, fun () -> n + 2)
  in
  evens_helper 0
;;

let letters =
  let rec letters_helper n =
    Cons (Char.chr ((n mod 26) + Char.code 'a'), fun () -> letters_helper (n + 1))
  in
  letters_helper 0
;;

let flips =
  let rec flips_helper next =
    Cons (next, fun () -> flips_helper (Random.bool ()))
  in
  Random.self_init ();
  flips_helper (Random.bool ())
;;

(** Exercise: nth. *)
let rec nth (Cons (h, t)) n =
  if n = 0 then h
  else nth (t ()) (n - 1)
;;

(** Exercise: filter. *)
let rec filter p (Cons (h, t)) =
  if p h then Cons (h, fun () -> filter p (t ()))
  else filter p (t ())
;;

(** Exercise: interleave. *)
let rec interleave a b =
  Cons (hd a, fun () -> interleave b (tl a))
;;

(** Exercise: sift. *)
let sift n =
  filter (fun x -> x mod n <> 0)
;;

(** Exercise: different sequence rep. *)
module DifferentSequence = struct
  type 'a sequence = Cons of (unit -> 'a * 'a sequence)
  
  let hd s = fst (s ())
  
  let tl s = snd (s ())

  let rec from n = Cons (fun () -> (n, from (n + 1)))
  
  let nats = from 0

  let rec map f (Cons s) =
    Cons (fun () -> (f (hd s), map f (tl s)))
end

(** Exercise: lazy hello. *)
let hello =
  lazy (print_endline "Hello lazy world") 

(** Exercise: lazy and. *)
let ( &&& ) a b =
  if Lazy.force a then Lazy.force b
  else false
;;

(** Exercise: lazy sequence. *)
module LazySeq = struct
  type 'a lazysequence = Cons of 'a * 'a lazysequence Lazy.t

  let rec map f (Cons (h, t)) =
    Cons (f h, fun () -> lazy (map f (Lazy.force t)))

  let rec filter p (Cons (h, t)) =
    if p h then Cons (h, fun () -> lazy (filter p (Lazy.force t)))
    else filter (Lazy.force t)
end

(** Exercise: promise and resolve. *)
module Promise = struct
  type 'a state = Pending | Resolved of 'a | Rejected of exn

  (** RI: the input may not be [Pending]. *)
  type 'a handler = 'a state -> unit

  (** RI: if [state <> Pending] then [handlers = []]. *)
  type 'a promise =
  { mutable state : 'a state
  ; mutable handlers : 'a handler list }

  let enqueue
    (handler : 'a state -> unit)
    (promise : 'a promise) : unit
    =
    promise.handlers <- handler :: promise.handlers

  type 'a resolver = 'a promise

  (** [write_once p s] changes the state of [p] to be [s]. If [p] and [s]
      are both pending, that has no effect.
      Raises: [Invalid_arg] if the state of [p] is not pending. *)
  let write_once p s =
    if p.state = Pending then p.state <- s
    else invalid_arg "cannot write twice"

  let make () =
    let p = {state = Pending; handlers = []} in
    p, p

  let return x =
    {state = Resolved x; handlers = []}

  let state p = p.state

  (** Requires: [st] may not be [Pending]. *)
  let resolve_or_reject (r : 'a resolver) (st : 'a state) =
    assert (st <> Pending);
    let handlers = r.handlers in
    r.handlers <- [];
    write_once r st;
    List.iter (fun f -> f st) handlers

  let reject r x =
    resolve_or_reject r (Rejected x)

  let resolve r x = 
    resolve_or_reject r (Resolved x)

  let handler (resolver : 'a resolver) : 'a handler = function
    | Pending -> failwith "handler RI violated"
    | Rejected exc -> reject resolver exc
    | Resolved x -> resolve resolver x

  let handler_of_callback
    (callback : 'a -> 'b promise)
    (resolver : 'b resolver) : 'a handler
    = function
      | Pending -> failwith "handler RI violated"
      | Rejected exc -> reject resolver exc
      | Resolved x ->
        let promise = callback x in
        match promise.state with
        | Resolved y -> resolve resolver y
        | Rejected exc -> reject resolver exc
        | Pending -> enqueue (handler resolver) promise
  
  let ( >>= )
      (input_promise : 'a promise)
      (callback : 'a -> 'b promise) : 'b promise
    =
    match input_promise.state with
    | Resolved x -> callback x
    | Rejected exc -> {state = Rejected exc; handlers = []}
    | Pending ->
      let output_promise, output_resolver = make () in
      enqueue (handler_of_callback callback output_resolver) input_promise;
      output_promise
end

let _ =
  let open Promise in
  let p, r = make () in
  let _ = p >>= (fun x -> Printf.printf "%d\n" x; return ()) in
  resolve r 4
;;
