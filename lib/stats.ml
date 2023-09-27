try
  begin match Sys.argv with
    | [|_; filename|] ->
      let stats = Textstat.stats_from_file filename in
      print_string "Words: ";
      print_int (Textstat.words stats);
      print_newline ();
      print_string "Characters: ";
      print_int (Textstat.chars stats);
      print_newline ();
      print_string "Sentences: "
      print_int (Textstat.stmts stats);
      print_newline ();
      print_string "Lines: ";
      print_int (Textstat.lines stats);
      print_newline ();
    | ->
      print_string "Usage: stats <filename>";
      print_newline ()
  end
with
  e ->
    print_string "An error occured: ";
    print_string (Printexc.to_string e);
    print_newline ();
    exit 1