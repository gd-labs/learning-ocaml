type stats

val lines : stats -> int

val chars : stats -> int

val words : stats -> int

val stmts : stats -> int

val stats_from_channel : in_channel -> stats

val stats_from_file : string -> stats