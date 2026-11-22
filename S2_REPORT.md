# S2 Report — Group 2

## S2.a — Input and output

The function `print-insert-result/0` reads three values from standard input in the following order:

1. The atom `x` to be inserted.
2. The possibly nested list `lst`.
3. The integer threshold `n`.

It calls `insert-if-short` with these values, displays the resulting nested list using `display`, and prints a newline.

The function does not display prompts or additional messages. The main source file contains only function definitions; `print-insert-result` is not called automatically when the file is loaded.

## S2.b — Helper functions and conditional insertion

Two helper functions are implemented without using the built-in `length` or `map` procedures.

- `my-length/1` calculates the number of top-level elements in a list using a named `let` recursion.
- `my-map/2` applies a supplied function to every element of a list while preserving the original order.

The function `insert-if-short/3` inserts the atom `x` at the beginning of every list whose original top-level length is strictly less than `n`.

The operation is performed recursively at every nesting level. Empty lists are treated as lists of length zero and are processed according to the same condition.

The length condition is evaluated using the original list, before insertion. Lists whose lengths are equal to or greater than `n` are left without an insertion at that level.

## S2.c — Higher-order function

The function `make-inserter/2` accepts an atom `x` and a predicate `len-ok?`.

It returns a one-argument function that recursively traverses a nested list. At each list, it calculates the original top-level length and checks the supplied predicate.

If the predicate returns true, `x` is inserted at the front of that list. Otherwise, the list is returned without an insertion at that level. Nested lists are processed recursively in either case.

The final `insert-if-short/3` definition uses `make-inserter` with the predicate:

```scheme
(lambda (len)
  (< len n))
```

This allows the insertion condition to be supplied separately from the recursive traversal logic.

## Testing and expected results

The test file `tests/test_q4.rkt` contains seven functional test cases covering:

- The first example from the assignment.
- The second example from the assignment.
- An empty top-level list with a positive threshold.
- An empty top-level list with a zero threshold.
- A list whose length is exactly equal to the threshold.
- A list whose length is less than the threshold.
- A nested empty list.

The expected results for the assignment examples are:

```scheme
((42 1 2) (3 4 5) (42 6) (42))

((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))
```

Additional boundary cases verify that an empty list is processed when the threshold is positive, but not when the threshold is zero. A list whose length equals the threshold is not modified.

The six functional test outputs previously run during development matched their expected results. The seventh nested-empty-list test is included in the test file and should also be run before final submission.

The input/output function should be tested separately with standard input containing:

```text
42
((1 2) (3 4 5) (6) ())
3
```

Expected output:

```text
((42 1 2) (3 4 5) (42 6) (42))
```

## Implementation restrictions

The implementation uses `#lang racket/base` and follows the permitted built-in function restrictions specified in the assignment.

In particular:

- `my-length` is implemented manually rather than using `length`.
- `my-map` is implemented manually rather than using `map`.
- Recursive traversal is used for nested lists.
- No mutation or imperative loops are used.
- The source file produces no output when loaded.

The solution was developed and tested using an online Racket environment. The exact Racket version should be checked, and the final tests should be run using Racket 8.x as specified in the assignment.

## Files

```text
S2_submission/
│
├── code/
│   └── 10_q4.rkt
│
├── tests/
│   └── test_q4.rkt
│
├── skills/
│   └── scheme-dev/
│       └── SKILL.md
│
├── prompts/
│   └── S2.md
│
└── README.md
```

The placeholder filename `id_q4.rkt` should be replaced with the required group-specific filename. The corresponding `require` path in the test file must be updated as well.

## Final verification checklist

- [ ] Confirm the implementation filename uses the correct group ID.
- [ ] Update the test file's import path.
- [ ] Run all seven functional tests.
- [ ] Test `print-insert-result` with standard input.
- [ ] Verify compatibility with Racket 8.x.
- [ ] Complete the S2 prompt log using the prompts actually used.
- [ ] Ensure the main source file contains definitions only.
- [ ] Include the S2 folder in the complete Group 10 repository.
