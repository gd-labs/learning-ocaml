type 'a tree =
  | Leaf
  | Node of 'a node

and 'a node =
{ value: 'a
; left: 'a tree
; right: 'a tree }

let rec size tree =
  match tree with
  | Leaf -> 0
  | Node {value = _; left; right} -> 1 + size left + size right
;;

(** [mem x t] is whether [x] is a value at some node in tree [t]. *)
let rec mem x tree =
  match tree with
  | Leaf -> false
  | Node {value; left; right} -> value = x || mem x left || mem x right

(** [preorder] computes the preorder traversal of a tree, in which
    each node is visited before any of its children *)
let rec preorder tree =
  match tree with
  | Leaf -> []
  | Node {value; left; right} -> [value] @ preorder left @ preorder right
;;

let preorder_lin tree =
  let rec pre_acc acc = function
    | Leaf -> acc
    | Node {value; left; right} -> value :: (pre_acc (pre_acc acc right) left)
  in pre_acc [] tree

(** [inorder] computes the inorder traversal of a tree, in which
    each node is visited after its left children and before its
    right children. *)
let rec inorder tree =
  match tree with
  | Leaf -> []
  | Node {value; left; right} -> inorder left @ [value] @ inorder right
;;

(** [postorder] computes the postorder traversal of a tree, in which
    each node is visited after any of its children. *)
let rec postorder tree =
  match tree with
  | Leaf -> []
  | Node {value; left; right} -> postorder left @ postorder right @ [value]
;;

let rec print_lst list =
  match list with
  | [] -> print_newline ()
  | x :: xs -> print_int x; print_string " "; print_lst xs
;;
  