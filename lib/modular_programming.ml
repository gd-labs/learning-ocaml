(** Exercise: complex synonym. *)
module type ComplexSig = sig
  type t = float * float

  val zero : t

  val add : t -> t -> t
end

(** Exercise: complex encapsulation. *)
module Complex : ComplexSig = struct
  type t = float * float

  let zero = (0., 0.)

  let add (r1, i1) (r2, i2) = r1 +. r2, i1 +. i2
end

(** Exercise: binary search tree map. *)
module type Map = sig
  (** [('k, 'v) t] is the type of maps that bind keys
      of type ['k] to values of type ['v]. *)
  type ('k, 'v) t

  (** [empty] does not bind any keys. *)
  val empty : ('k, 'v) t

  (** [insert k v m] is the map that binds [k] to [v],
      and also contains all the bindings of [m]. If
      [k] was already bound in [m], that old binding
      is superseded by the binding to [v] in the
      returned map. *)
  val insert : 'k -> 'v -> ('k, 'v) t -> ('k, 'v) t

  (** [lookup k m] is the value bound to [k] in [m].
      Raises: [Not_found] if [k] is not in [m]. *)
  val lookup : 'k -> ('k, 'v) t -> 'v

  (** [bindings m] is an association list containing
      the same bindings as [m]. The keys in the list
      are guaranteed to be unique. *)
  val bindings : ('k, 'v) t -> ('k * 'v) list
end

module BstMap : Map = struct
  type 'a tree =
  | Leaf
  | Node of 'a * 'a tree * 'a tree

  type ('k, 'v) t = ('k * 'v) tree

  let empty = Leaf

  let rec insert k v = function
    | Leaf -> Node((k, v), Leaf, Leaf)
    | Node ((k', v'), l, r) -> (
      if k = k' then
        Node((k', v'), l, r)
      else if k < k' then
        Node ((k', v'), insert k v l, r)
      else
        Node ((k', v'), l, insert k v r)
    )
  
  let rec lookup k = function
    | Leaf -> raise Not_found
    | Node ((k', v'), l, r) -> (
      if k = k' then
        v'
      else if k < k' then
        lookup k l
      else
        lookup k r
    )

  let bindings t =
    let rec preorder acc = function
      | Leaf -> acc
      | Node((k, v), l, r) -> preorder (preorder ((k, v) :: acc) l) r
    in
    preorder [] t
end

(** Exercise: fraction. *)
module type Fraction = sig
  (* A fraction is a rational number p/q where q != 0. *)
  type t

  val make : int -> int -> t

  val numerator : t -> int

  val denominator : t -> int

  val to_string : t -> string

  val to_float : t -> float

  val add : t -> t -> t

  val mul : t -> t -> t
end

module Fraction : Fraction = struct
  type t = int * int

  let make a b =
    assert (b > 0);
    (a, b)

  let numerator (a, _) = a

  let denominator (_, b) = b

  let to_string (a, b) =
    string_of_int a ^ "/" ^ string_of_int b

  let to_float (a, b) =
    float_of_int a /. float_of_int b

  let add (a, b) (a', b') =
    let c = b * b' in
    (a * b' + b * a', c)

  let mul (a, b) (a', b') =
    a * a', b * b'
end

(** Exercise: date order. *)
type date = 
{ month: int
; day: int }

module Date = struct
  type t = date

  let compare d1 d2 =
    let m = d1.month - d2.month in
    if m != 0 then m
    else d1.day - d2.day
end