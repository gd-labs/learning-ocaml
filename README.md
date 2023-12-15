# learning-ocaml

Project following the book [OCaml Programming: Correct + Efficient + Beautiful](https://cs3110.github.io/textbook/ocaml_programming.pdf) serving as an introduction both to the OCaml programming language and the ideas behind functional programming in general.

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

## Fold on variant types (6.5.2)

Applying the fold functional for any variant type in OCaml can be done as follows: 

- Write a recursive `fold` function that takes in one argument for each constructor of `t`.

- The function matches against the constructors, calling itself on any value of type `t`.

- Use the appropriate argument of `fold` to combine the results of all recursive calls.

This technique constructs something called a *catamorphism*, or a *generalized fold operation*.

## Pattern matching performance

The idea of pattern matching not being performant is addressed in the book [Real World OCaml](https://dev.realworldocaml.org/lists-and-patterns.html), which states that:

> Naively, you might think that it would be necessary to check each case in a **match** sequence to figure out which one fires; If the cases of a match were guarded by arbitrary code, that would be the case. But OCaml is often able to generate machine code that jumps directly to the matched case based on an efficiently chosen set of runtime checks.

The main difference between a match-based implementation and an if-based one is that the latter usually leads to a repetition of efforts, whereas the former is applied exactly once in the context of a single element.

## Modular programming (7.0)

> One key solution to managing complexity of large software is *modular programming*: the code is composed of many different code modules that are developed separately. This allows different developers to take on discrete pieces of the system and design and implement them without having to understand all the rest. But to build large programs out of modules effectively, we need to be able to write modules that we can convince ourselves are correct *in isolation* from the rest of the program.
>
> Rather than have to think about every other part of the program when developing a code module, we need to be able to use *local reasoning*: that is, reasoning about just the module and the contract it needs to satisfy with respect to the rest of the program. If everyone has done their job, separately developed code modules can be plugged to form a working program without every developer needing to understand everything done by every other developer in the team. This is the key idea of **modular programming**.

## Subtyping (7.2.4)

A more complete notion of subtyping is defined by [Barbara Liskov](https://dl.acm.org/doi/pdf/10.1145/197320.197383). But briefly:

> If *S* is a subtype of *T*, then substituting an object of type *S* for an object of type *T* should not change any desirable behaviors of a program.

## Functional data structures (7.6)

A **functional data structure** is one that doesn't make use of mutability, which implies the property of being **persistent**, meaning that updating the data structure with some kind of operation does not change its existing version, instead it produces a new one so that both versions still exist and can be accessed at any time. Aiming for such a pattern may lead to some memory overheads, so a good language implementation generally ensures that any parts of the data structure that are not changed by an operation will be **shared** between the old and the new versions. Any parts that do change will be **copied** so that the previous model persists.

> The opposite of a persistent data structure is an *ephemeral* data structure: changes are destructive, so that only one version exists at any time. Both persistent and ephemeral data structures can be built in both functional and imperative languages.

## Dependent types (7.9.2)

> Functor types are an example of an advanced programming language feature called *dependent types*, with which the **type** of an output is determined by the **value** of an input. That's different than the normal case of a function, where it's the output **value** that's determined by the input **value**, and the output type is independent of the input value.
>
> Dependent types enable type systems to express much more about the correctness of a program, but type checking and inference for dependent types is much more challenging. Practical dependent types systems are an active area of research.

## Documentation and Testing (8.0)

> **Documentation** is a ground truth of what a programmer intended, as opposed to what whey actually wrote. It communicates to other humans the ideas the author had in their head. Maybe the failure occurs in the code, or maybe in the documentation. But writing documentation forces one to think a second time about one's intentions. The cognitive task of explaining ideas to other humans is certaily different than explaining ideas to the computer. That can expose failures in thinking.
>
> **Testing** is the ground truth of what a program actually does, as opposed to that the programmer intended. It provides evidence that the programmer got it right. One can write a piece of code that one thinks is right, but a test can be written in order to *demonstrate* it's right.

## Abstraction by Specification (8.1)

> Abstraction enables modular programming by hiding the details of implementations. Specifications are part of that kind of abstraction: they reveal certain information about the behavior of a module without disclosing all the details of the module's implementation.
>
> *Locality* is one of the benefits of abstraction by specification. A module can be understood without needing to examine its implementation. This locality is critical in implementing large programs, and even in implementing smaller programs in teams. No one person can keep the entire system in their head at a time.
>
> *Modifiability* is another benefit. Modules can be reimplemented without changing the implementation of other modules or functions. Software libraries depend upon this to improve their functionality without forcing all their clients to rewrite code every time a library is upgraded. Modifiability also enables performance enhancements: simple, slow implementations can be written at first, then bottlenecks are applied as necessary.
>
> A client should not assume more about the implementation than is given in the specification because that allows the implementation to change. The specification forms an *abstraction barrier* that protects the implementer from the client and vice versa. Making assumptions about the implementation that are not guaranteed by the specification is known as *violating the abstraction barrier*. The abstraction barrier enforces local reasoning. Further, it promotes *loose coupling* between different code modules. If one module changes, other modules are less likely to have to change to match.

## Debugging (8.4.2)

> Inevitably though, you will discover faults in your programs. When you do, approach them as a scientist by employing the *scientific method*:
> - evaluate the data that are available;
> - formulate a hypothesis that might explain the data;
> - design a repeatable experiment to test the hypothesis; and
> - use the result of that experiment to refine or refute your hypothesis
>
> Often the crux of this process is finding the simplest, smallest input that triggers a fault. That's not usually the original input for which we discover a fault. So some initial experimentation might be needed to find a *minimal test case*. 