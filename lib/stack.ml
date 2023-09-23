module type Stack = sig
  type 'a t
  (** [Empty] is raised when an operation cannot
      be applied to an empty stack. *)
  exception Empty
  (** [empty] is the empty stack. *)
  val empty: 'a t

  val is_empty: 'a t -> bool

  (** [push x s] pushes [x] onto the top of [s]. *)
  val push: 'a -> 'a t -> 'a t

  (** [peek s] is the top element of [s].
      Raises  [Empty] if [s] is empty. *)
  val peek: 'a t -> 'a
  
  (** [pop s] is all but the top element of [s].
  Raises [Empty] if [s] is empty. *)
  val pop: 'a t -> 'a t

  (** [size s] is the number of elements on the stack. *)
  val size: 'a t -> int
end

module ListStack: Stack = struct
  type 'a t = 'a list
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

  let size s = List.length s
end

module ListStackCachedSize: Stack = struct
  type 'a t = 'a list * int

  exception Empty

  let empty = ([], 0)

  let is_empty = function
    |([], _) -> true
    | _ -> false

  let push x (stack, size) = (x :: stack, size + 1)

  let peek = function
    | ([], _) -> raise Empty
    | (x :: _, _) -> x

  let pop = function
    | ([], _) -> raise Empty
    | (_ :: stack, size) -> (stack, size - 1) 

  let size = snd
end

module CustomStack: Stack = struct
  type 'a entry = {top: 'a; rest: 'a t; size: int}
  
  and 'a t = S of 'a entry option

  exception Empty

  let empty = S None

  let is_empty = function
    | S None -> true
    | _ -> false

  let size = function
    | S None -> 0
    | S (Some {size}) -> size

  let push x s =
    S (Some {top = x; rest = s; size = size s +1})

  let peek = function
    | S None -> raise Empty
    | S (Some {top}) -> top

  let pop = function
    | S None -> raise Empty
    | S (Some {rest}) -> rest
end