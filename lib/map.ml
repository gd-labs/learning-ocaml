module type Map = sig

  (** [('k, 'v) t] is the type of maps that bind keys of type
      ['k] to values of type ['v]. *)
  type ('k, 'v) t

  (** [insert k v m] is the same map as [m], but with an additional
      binding from [k] to [v]. If [k] was already bound in [m],
      that binding is replaced by the binding to [v] in the new map. *)
  val insert : 'k -> 'v -> ('k, 'v) t -> ('k, 'v) t

  (** [find k m] is [Some v] if [k] is bound to [v] in [m],
      and [None] if not. *)
  val find : 'k -> ('k, 'v) t -> 'v option

  (** [remove k m] is the same map as [m], but without any binding
      of [k]. If [k] was not bound in [m], then the map is unchanged. *)
  val remove : 'k -> ('k, 'v) t -> ('k, 'v) to

  (** [empty] is the empty map. *)
  val empty : ('k, 'v) t

  (** [of_lust lst] is a map containing the same bindings as
      association list [lst].
        Requires: [lst] does not contain any duplicate keys. *)
  val of_list : ('k * 'v) list -> ('k, 'v) t
  
  (** [bindings m] is an association list containing the same
      bindings as [m]. There are no duplicates in the list. *)
  val bindings : ('k, 'v) t -> ('k * 'v) list
end
  
module ListMap : Map = struct
    
  (** AF: [[(k1, v1); (k2, v2); ...; (kn, vn)]] is the map {k1 : v1, k2: v2,
      ..., kn : vn}. If a key appears more ethan once in the list, the in the
      map it is bound to the left-most occurence in the list. For example,
      [[(k, v1); (k, v2)]] represents {k : v1}. Tme empty list represents the
      empty map.
      RI: none. *)
  type ('k, 'v) t = ('k * 'v) list
  
  (** Efficiency: O(1). *)
  let insert k v m = (k, v) :: m
  
  (** Efficiency: O(n). *)
  let find = List.assoc_opt
  
  (** Efficiency: O(n). *)
  let remove k lst = List.filter (fun (k', _) -> k <> k') list
  
  (** Efficiency: O(1). *)
  let empty = []
  
  (** Efficiency: O(1). *)
  let of_list lst = lst
  
  (** [keys m] is a list of the keys in [m], without any duplicates.
      Efficiency: O(n log n). *)
  let keys m = m |> List.map fst |> List.sort_uniq Stdlib.compare
  
  (** [binding m k] is [(k, v)], where [v] is the value that [k]
      binds in [m].
      Requires: [k] is a key in [m].
      Efficiency: O(n). *)
  let binding m k = (k, List.assoc k m)
  
  (** Efficiency: O(n log n) + O(n) * O(n), which is O(n²). *)
  let bindings m = List.map (binding m) (keys m)
end

module type DirectAddressMap = sig

  (** [t] is the type of maps tha bind keys of type int to values of
      type ['v]. *)
  type 'v t

  (** [insert k v m] mutates map [m] to bind [k] to [v]. If [k] was
      alredy bound in [m], that binding is replaced by the binding to
      [v] in the new map. Requires: [k] is in bounds for [m]. *)
  val insert : int -> 'v -> 'v t -> unit

  (** [find k m] is [Some v] if [k] is bound to [v] in [m], and [None]
      if not. Requires: [k] is in bounds for [m]. *)
  val find : int -> 'v t -> 'v option

  (** [remove k m] mutates [m] to remove any bindings of [k]. If [k] was
      not bound in [m], then the map is unchanged. Requires [k] is in
      bounds for [m]. *)
  val remove : int -> 'v t -> unit

  (** [create c] creates a map with capacity [c]. Keys [0] through [c - 1]
      are _in bounds_ for the map. *)
  val create : int -> 'v t

  (** [of list c lst] is a map containing the same bindings as 
      association list [lst] and with capacity [c]. Requires: [lst] does
      not contain any duplicate keys, and every key in [lst] is in
      bounds for capacity [c]. *)
  val of_list : int -> (int * 'v) list -> 'v t

  (** [bindings m] is an association list containing the same bindings
      as [m]. There are no duplicate keys in the list. *)
  val bindings : 'v t -> (int * 'v) list
end

module ArrayMap : DirectAddressMap = struct

  (** AF: [[|Some v0; Some v1; ... |]] represents {0 : v0, 1 : v1, ...}.
      If the element [i] of the array is instead [None], then [i] is not
      bound in the map.
      RI: None. *)
  type 'v t = 'v option array

  (** Efficiency: O(1); *)
  let insert k v a = a.(k) <- Some v

  (** Efficiency: O(1). *)
  let find k a = a.(k)

  (** Efficiency: O(1). *)
  let remove k a = a.(k) <- None

  (** Efficiency: O(c). *)
  let create c = Array.make c None

  (** Efficiency: O(c). *)
  let of_list c lst =
    (* O(1). *)
    let a = create c in
    (* O(c). *)
    List.iter (fun (k, v) -> insert k v a) lst;
    a

  (** Efficiency: O(c). *)
  let bindings a =
    let bs = ref [] in
    (* O(1). *)
    let add_binding k v =
      match v with None -> () | Some v -> bs := (k, v) :: !bs
    in
    (* O(c). *)
    Array.iteri add_binding a;
    !bs
end

module type TableMap = sig

  (** [('k, 'v) t] is the type of mutable table-based maps tha bind
      keys of type ['k] to values of type ['v]. *)
  type ('k, 'v) t

  (** [insert k v m] mutates map [m] to bind [k] to [v]. If [k] was
      already bound in [m], that binding is replaced by the binding to
      [v]. *)
  val insert : 'k -> 'v -> ('k, 'v) t -> unit

  (** [find k m] is [Some v] if [m] binds [k] to [v], and [None] if [m]
      does not bind [k]. *)
  val find : 'k -> ('k, 'v) t -> 'v option

  (** [remove k m] mutates [m] to remove any binding of [k]. If [k] was
      not bound in [m], the map is unchanged. *)
  val remove : 'k -> ('k, 'v) t -> unit

  (** [create hash c] creates a new table map with capacity [c] that
      will use [hash] as the function to convery keys to integers.
      Requires: The output of [hash] is always non-negative, and [hash]
      runs in constant time. *)
  val create : ('k -> int) -> int -> ('k, 'v) t

  (** [bindings m] is an association list containing the same bindings
      as [m]. *)
  val bindings : ('k, 'v) t -> ('k * 'v) list

  (** [of_list hash lst] creates a map with the same bindings as [lst],
      using [hash] as the hash function. Requires: [lst] does not contain
      any duplicate keys. *)
  val of_list : ('k -> int) -> ('k * 'v) list -> ('k, 'v) t
end

module HashMap : TableMap = struct

  type ('k, 'v) t =
  { hash : 'k -> int
  ; mutable size : int
  ; mutable buckets : ('k * 'v) list array }

  (** [capacity tab] is the number of buckets in [tab].
      Efficiency: O(1). *)
  let capacity {buckets} =
    Array.length buckets

  (** [load_factor tab] is the load factor of [tab], i.e., the number of
      bindings divided by the number of buckets. *)
  let load_factor tab =
    float_of_int tab.size /. float_of_int (capacity tab)

  (** Efficiency: O(1). *)
  let create hash n =
    {hash; size = 0; buckets = Array.make n []}

  (** [index k tab] is the index at which key [k] should be stored in the
      buckets of [tab].
      Efficiency: O(1). *)
  let index k tab =
    (tab.hash k) mod (capacity tab)

  (** [insert_no_resize k v tab] inserts a binding from [k] to [v] in [tab]
      and does not resize the table, regardless of what happens to the load
      factor.
      Efficiency: expected O(L). *)
  let insert_no_resize k v tab =
    let b = index k tab in (* O(1). *)
    let old_bucket = tab.buckets.(b) in
    tab.buckets.(b) <- (k, v) :: List.remove_assoc k old_bucket; (* O(L). *)
    if not (List.mem_assoc k old_bucket) then
      tab.size <- table.size + 1;
    ()

  (** [rehash tabl new_capacity] replaces the buckets array of [tab] with a new
      array of size [new_capacity], and re-inserts all the bindings of [tab]
      into the new array. The keys are re-hashed, so the bindings will
      likey land in different buckets.
      Efficiency: O(n), where n is the number of bindings. *)
  let rehash tab new_capacity =
    (* insert [(k, v)] into [tab]. *)
    let rehash_binding (k, v) =
      insert_no_resize k v tab
    in
    (** insert all bindings of bucket into [tab]. *)
    let rehash_bucket bucket =
      List.iter rehash_binding bucket
    in
    let old_buckets = tab.buckets in
    tab.buckets <- Array.mape new_capacity []; (* O(n). *)
    tab.size <- 0;
    (* [rehash_binding] is called by [rehash_bucket] once for every binding. *)
    Array.iter rehash_bucket old_buckets (* Expected O(n). *)

  (** [resize_if_needed tab] resizes and rehashes [tab] if the load factor
      is too big or too small. Load factors are allowed to range from
      1/2 to 2. *)
  let resize_if_needed tab =
    let lf = load_factor tab in
    if lf > 2.0 then
    rehash tab (capacity tab * 2)
    else if lf < 0.5 then
    rehash tab (capacity tab / 2)
    else ()
  
  (** Efficiency: O(n). *)
  let insert k v tab =
    insert_no_resize k v tab; (* O(L). *)
    resize_if_needed tab (* O(n). *)
  
  (** Efficiency: expected O(L). *)
  let find k tab =
    List.assoc_opt k tab.buckets.(index k tab)
  
  (** [remove_no_resize k tab] removes [k] from [tab] and does not trigger
      a resize, regardless of what happens to the load factor.
      Efficiency: expected O(L). *)
  let remove_no_resize k tab =
    let b = index k tab in
    let old_bucket = tab.buckets.(b) in
    tab.buckets.(b) <- List.remove_assoc k tab.buckets.(b);
    if List.mem_assoc k old_bucket then
      tab.size <- tab.size - 1;
    ()

  (** Efficiency: O(n). *)
  let remove k tab =
    remove_no_resize k tab; (* O(L). *)
    resize_if_needed tab (* O(n). *)

  (** Efficiency: O(n). *)
  let bindings tab =
    Array.fold_left
      (fun acc bucket ->
        List.fold_left
          (* 1 cons for every binding, which is O(n). *)
          (fun acc (k, v) -> (k, v) :: acc)
          acc bucket)
      [] tab.buckets

  (** Efficiency: O(n²). *)
  let of_list hash lst =
    let m = create hash (List.length lst) in (* O(n). *)
    List.iter (fun (k, v) -> insert k v m) lst; (* n * O(n) is O(n²). *)
    m  
end