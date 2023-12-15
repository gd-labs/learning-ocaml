module type MutableStack = sig

  (** [*a t] is the type of mutable stacks whose elements have type [*a].
      The stack is mutable not in the sense that its elements can be
      changed, but in the sense that it is not persistent: the operations
      [push] and [pop] destructively modify the stack. *)
  type 'a t

  (** Raised if [peek] or [pop] encounter the empty stack. *)
  exception Empty

  (** [empty ()] is the empty stack. *)
  val empty : unit -> 'a t

  (** [push x s] modifies [s] to make [x] its top element.
      The rest of the elements are unchanged. *)
  val push : 'a -> 'a t -> unit

  (** [peek s] is the top element of [s].
      Raises: [Empty] if [s] is empty. *)
  val peek : 'a t -> 'a

  (** [pop s] removes the top element of [s].
      Raises: [Empty] if [s] is empty. *)
  val pop : 'a t -> unit
end

module MutableRecordStack : MutableStack = struct
  type 'a node = {value: 'a; mutable next: 'a node option}

  type 'a t = {mutable top: 'a node option}

  exception Empty

  let push x s = s.top <- Some {value = x; next = s.top}

  let peek s =
    match s.top with
    | None -> raise Empty
    | Some {value} -> value

  let pop s =
    match s.top with
    | None -> raise Empty
    | Some {next} -> s.top <- next
end