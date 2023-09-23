module type ListStack = sig
  type 'a stack
  (** [Empty] is raised when an operation cannot
      be applied to an empty stack. *)
  exception Empty
  (** [empty] is the empty stack. *)
  val empty: 'a stack

  val is_empty: 'a stack -> bool

  (** [push x s] pushes [x] onto the top of [s]. *)
  val push: 'a -> 'a stack -> 'a stack

  (** [peek s] is the top element of [s].
      Raises  [Empty] if [s] is empty. *)
  val peek: 'a stack -> 'a
  
  (** [pop s] is all but the top element of [s].
  Raises [Empty] if [s] is empty. *)
  val pop: 'a stack -> 'a stack

  (** [size s] is the number of elements on the stack. *)
  val size: 'a stack -> int
end

module ListStackCachedSize : ListStack = struct
  type 'a stack = 'a list * int

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

module ListStack : ListStack = struct
  type 'a stack = 'a list
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