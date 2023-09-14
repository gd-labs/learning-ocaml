# learning-ocaml

Project following the book [OCaml Programming: Correct + Efficient + Beautiful](https://cs3110.github.io/textbook/ocaml_programming.pdf) serving as an introduction both to the OCaml programming language and the idea behind functional programming in general.

# The recipe for Tail Recursion (4.4)

1. Change the function into a helper function. Add an extra argument: the accumulator.

2. Call the helper in the original function passing the original base case's return value as the accumulator value.

3. Change the helper function to return the accumulator in the base case.

4. Change the hekper function's recursive case.

# Defensive programming

> Sometimes programmers worry unnecessarily that defensive programming will be too expensive, either in terms of the time it costs them to implements the checks initially, or in the run-time costs that will be paid in checking assertions. These concerns are far too often misplaced. The time and money it costs society to repair faults in software suggests that we could all afford to have programs that run a little more slowly.

# Test-driven development

- Write a failing unit test case.

- Implement enough funcionality to make the test case pass.

- Improve code as needed.

- Repeat until the test suite provides evidence that implementation is correct.