module type Queue = sig
  (** An ['a t] is a queue whose elements have type 'a. *) 
  type 'a t

  (** Raised if [front] or [dequeue] is applied to the empty queue. *)
  exception Empty

  (** [empty] is the empty queue. *)
  val empty : 'a t

  (** [is_empty q] is whether [q] is empty. *)
  val is_empty : 'a t -> bool

  (** [enqueue x q] is the queue [q] with [x] added to the end. *)
  val enqueue : 'a -> 'a t -> 'a t

  (** [front q] is the element at the front of the queue.
      Raises [Empty] if [q] is empty. *)
  val front : 'a t -> 'a
  
  (** [dequeue q] is the queue containing all the elements of [q]
      except the front of [q]. Raises [Empty] if [q] is empty. *)
  val dequeue : 'a t -> 'a t
  
  (** [size q] is the number of elements in [q]. *)    
  val size : 'a t -> int

  (** [to_list q] is a list containing the elements of [q] in
      order from front to back. *)
  val to_list : 'a t -> 'a list
end

module ListQueue : Queue = struct
  type 'a t = 'a list

  exception Empty

  let empty = []

  let is_empty = function
    | [] -> true
    | _ -> false

  let enqueue x q = q @ [x]

  let front = function
    | [] -> raise Empty
    | h :: _ -> h

  let dequeue = function
    | [] -> raise Empty
    | _ :: q -> q

  let size = List.length

  let to_list = Fun.id
end