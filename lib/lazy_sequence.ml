module LazyFibs = struct
  type 'a lazysequence = Cons of 'a * 'a lazysequence Lazy.t

  let hd : 'a lazysequence -> 'a =
    fun (Cons (h, _)) -> h

  let tl : 'a lazysequence -> 'a lazysequence =
    fun (Cons (_, t)) -> Lazy.force t

  let rec take_aux n (Cons (h, t)) lst =
    if n = 0 then lst
    else take_aux (n - 1) (Lazy.force t) (h :: lst)
    
  let take: int -> 'a lazysequence -> 'a list =
    fun n s -> List.rev (take_aux n s [])

  let nth : int -> 'a lazysequence -> 'a =
    fun n s -> List.hd (take_aux (n + 1) s [])

  let rec sum : int lazysequence -> int lazysequence -> int lazysequence =
    fun ((Cons (h_a, t_a)) (Cons (h_b, t_b)) ->
      Cons (h_a + h_b, lazy (sum (Lazy.force t_a) (Lazy.force t_b))))

  let rec fibs =
    Cons (1, lazy (
      Cons (1, lazy (
        sum (tl fibs) fibs))))
  
  let nth_fib n =
    nth n fibs
end