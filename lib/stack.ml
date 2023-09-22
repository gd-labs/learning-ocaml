module type LIST_STACK = sig
  (** [Empty] is raised when an operation cannot
      be applied to an empty stack. *)
  exception Empty
  (** [empty] is the empty stack. *)
  val empty: 'a list

  val is_empty: 'a list -> bool

  (** [push x s] pushes [x] onto the top of [s]. *)
  val push: 'a -> 'a list -> 'a list

  (** [peek s] is the top element of [s].
      Raises  [Empty] if [s] is empty. *)
  val peek: 'a list -> 'a
  
  (** [pop s] is all but the top element of [s].
  Raises [Empty] if [s] is empty. *)
  val pop: 'a list -> 'a list
end

module ListStack: LIST_STACK = struct  
  let empty = []
  
  let is_empty = function [] -> true | _ -> false

  let push x s = x :: s

  exception Empty

  let peek = function
    | [] -> raise Empty
    | x :: _ -> x

  let pop = function
    | [] -> raise Empty
    | _ :: s -> s
end