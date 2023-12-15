(** Exercise: mutable fields. *)
type student =
{ name: string
; mutable gpa: float }

let alice = {"Alice"; 3.7}