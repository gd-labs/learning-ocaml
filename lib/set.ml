module type Set = sig
  (** ['a t] is the type of sets whose elements are of type ['a]. *)
  type 'a t

  (** [empty] is the empty set. *)
  val empty : 'a t

  (** [mem x s] is whether [x] is an element of [s]. *)
  val mem : 'a -> 'a t -> bool

  (** [add x s] is the set that contains [x] and all elements
      of [s]. *)
  val add : 'a -> 'a t -> 'a t

  (** [elements s] is a list containing the elements of [s]. No
      guarantee is made about the ordering of that list, but
      each is guaranteed to be unique. *)
  val elements : 'a t -> 'a list
end

module UniqListSet : Set = struct
  type 'a t = 'a list

  let empty = []

  let mem = List.mem

  let add x s = if mem x s then s else x :: s

  let elements = Fun.id
end

module ListSet = struct
  type 'a t = 'a list

  let empty = []

  let mem = List.mem

  let add = List.cons

  let elements s = List.sort_uniq Stdlib.compare s
end

module SetOfList (S : Set) = struct
  include S
  let of_list lst = List.fold_right S.add lst S.empty
end

module OfList = SetOfList (ListSet)
module UniqOfList = SetOfList (UniqListSet)