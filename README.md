# learning-ocaml

Project following the book [OCaml Programming: Correct + Efficient + Beautiful](https://cs3110.github.io/textbook/ocaml_programming.pdf) serving as an introduction both to the OCaml programming language and the idea behind functional programming in general.

## The recipe for Tail Recursion (4.4)

1. Change the function into a helper function. Add an extra argument: the accumulator.

2. Call the helper in the original function passing the original base case's return value as the accumulator value.

3. Change the helper function to return the accumulator in the base case.

4. Change the hekper function's recursive case.

## Defensive programming (4.7)

> Sometimes programmers worry unnecessarily that defensive programming will be too expensive, either in terms of the time it costs them to implements the checks initially, or in the run-time costs that will be paid in checking assertions. These concerns are far too often misplaced. The time and money it costs society to repair faults in software suggests that we could all afford to have programs that run a little more slowly.

## Test-driven development (5.3)

- Write a failing unit test case.

- Implement enough funcionality to make the test case pass.

- Improve code as needed.

- Repeat until the test suite provides evidence that implementation is correct.

## Algebraic data types (5.9)

Another name for variant types. The "algebraic" refers to the fact that these types contain both sum and product types, where sum types impose that their values are composed by **one** of many underlying sets and product types imply that their values are composed by elements from **each of many** underlying sets.

## The meaning of "higher-order" (6.1.2)

In logic, *first order quantification* refers primarily to the universal and existential quantifiers. These make it possible to quantify over some *domain* of interest, such as the natural numbers.

In programming languages *first-order functions* similarly refer to functions that operate on individual data elements. Whereas *higher-order functions* can operate on functions, much like higher-order logics can quantify over properties of some domain (which are like functions).