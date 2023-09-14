# learning-ocaml

Project following the book [OCaml Programming: Correct + Efficient + Beautiful](https://cs3110.github.io/textbook/ocaml_programming.pdf) serving as an introduction both to the OCaml programming language and the idea behind functional programming in general.

# The recipe for Tail Recursion (4.4)

1. Change the function into a helper function. Add an extra argument: the accumulator.

2. Write a new version of the function that calls the helper that passes the original base case's return value as initial accumulator value.

3. Change the helper function to return the accumulator in the base case.

4. Change the hekper function's recursive case.