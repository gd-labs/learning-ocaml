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

type 'a tree =
  | Leaf
  | Node of 'a * 'a tree * 'a tree
;;

let rec map_tree f = function
  | Leaf -> Leaf
  | Node (v, l, r) ->
      Node (f v, map_tree f l, map_tree f r)
;;

let rec fold_tree f acc = function
  | Leaf -> acc
  | Node (v, l, r) ->
      f v (fold_tree f acc l) (fold_tree f acc r)
;;

let fold_size t = fold_tree (fun _ l r -> 1 + l + r) 0 t

let fold_depth t = fold_tree (fun _ l r -> 1 + max l r) 0 t

let fold_preorder t = fold_tree (fun v l r -> [v] @ l @ r) [] t

let rec filter_tree p = function
  | Leaf -> Leaf
  | Node (v, l, r) -> 
      if (p v) then Node (v, filter_tree p l, filter_tree p r)
      else Leaf
;;
