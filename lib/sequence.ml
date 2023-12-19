(** An ['a sequence] is an infinite list of values of type ['a].
    AF: [Cons (x, f)] is the sequence whose head is [x] and tail is [f ()].
    RI: None. *)
type 'a sequence = Cons of 'a * (unit -> 'a sequence)

(** [hd s] is the head of [s]. *)
let hd (Cons (h, _)) = h

(** [tl s] is the tail of [s]. *)
let tl (Cons (_, t)) = t ()

(** [take n s] is the list of the first [n] elements of [s]. *)
let rec take n s =
  if n = 0 then [] else hd s :: take (n - 1) (tl s)

(** [drop n s] is all but the first [n] elements of [s]. *)
let rec drop n s =
  if n = 0 then s else drop (n - 1) (tl s)

(** [square <a; b; c; ...>] is [<a * a>; b * b; c * c; ...]*)
let rec square (Const (h, t)) =
  Const (h * h, fun () -> square (t ()))

(** [sum <a1; a2; a3; ...> <b1; b2; b3; ...>] is
    [<a1 + b1; a2 + b2; a3 + b3; ...>]. *)
let rec sum (Cons (h1, t1)) (Cons (h2, t2)) =
  Cons (h1 + h2, fun () -> sum (t1 ()) (t2 ()))

(** [map f <a; b; c; ...>] is [<f a; f b; f c; ...>]. *)
let rec map f (Cons (h, t)) =
  Cons (f h, fun () -> map f (t ()))

(** [map2 f <a1; b1; c1; ...> <a2; b2; c2; ...>] is
    [<f a1 b1; f b1 b2; f c1 c2; ...>]. *)
let rec map2 f (Cons (h1, t1)) (Cons (h2, t2)) =
  Cons (f h1 h2, fun () -> map2 f (t1 ()) (t2 ()))
