type stats = int * int * int * int

let lines (l, _, _, _) = l

let chars (_, c, _, _) = c

let words (_, _, w, _) = w

let stmts (_, _, _, s) = s

let stats_from_channel in_channel =
  let lines = ref 0 in
  let chars = ref 0 in
  let words = ref 0 in
  let stmts = ref 0 in
  try
    while true do
      let line = input_line in_channel in
      lines := !lines + 1;
      chars := !chars + String.length line;
      String.iter(
        fun c -> match c with
          | '.' | '?' | '!' -> stmts := !stmts + 1
          | ' ' -> words := !words + 1
          | _ -> ()
      )
      line
    done;
    (0, 0, 0, 0)
  with
    End_of_file -> (!lines, !chars, !words, !stmts)
;;

let stats_from_file filename =
  let channel = open_in filename in
  let result = stats_from_channel channel in
  close_in channel;
  result
;;