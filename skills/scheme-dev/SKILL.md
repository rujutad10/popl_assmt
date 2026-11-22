
---
name: scheme-dev
description: Development and review instructions for Racket solutions in CS F301 Assignment 2, covering S1 and S2.
---

# Scheme Development Skill

## 1. Language and Environment

- Use Racket 8.x.
- Every source file must begin with `#lang racket/base`.
- Use only the built-in functions explicitly permitted in the assignment.
- S2 additionally permits `read`.

## 2. Assignment Restrictions

The permitted forms and functions include:

- Definitions: `define`, `lambda`
- Local bindings: `let`, `let*`, `letrec`, named `let`
- Conditionals: `if`, `cond`, `and`, `or`, `not`
- List operations: `cons`, `car`, `cdr`, `list`
- Predicates: `null?`, `pair?`, `eq?`
- Association operations: `assq`, `assoc`
- Arithmetic and comparisons: `+`, `-`, `*`, `<`, `>`, `<=`, `>=`, `=`, `max`
- Output: `display`, `newline`
- Input for S2: `read`
- Quotation: `'` and `quote`

Do not use unlisted functions or forms.

In particular, do not use:

- `length`, `map`, `append`, `reverse`
- `filter`, `member`, `memq`
- `list-ref`, `list-tail`
- `set!` or other mutation
- Vectors, hash tables, strings
- Imperative loops such as `for` and `do`
- `require` or `provide`

If a required operation is unavailable, implement it using permitted functions.

## 3. Coding Conventions

- Use descriptive function names.
- Prefer recursion and named `let` where appropriate.
- Prefer tail recursion for long list-processing operations.
- Pass state through function arguments.
- Preserve the original order of list elements.
- Use `letrec` when recursive local functions are needed.
- Add comments for non-obvious logic.
- Keep the submitted source files limited to definitions.
- Do not execute functions automatically when a source file is loaded.

## 4. S1 — Binary Tree Traversals

The S1 solution must implement:

- `print-inorder`
- `print-all-traversals`
- `print-height-and-leaves`

Review requirements:

- Handle the empty tree correctly.
- Visit the left subtree before the right subtree.
- Preserve the required inorder, preorder, and postorder traversal orders.
- Calculate height using the specified convention: empty tree has height 0.
- Count leaves correctly.
- Print the required output followed by a newline.

## 5. S2 — Conditionally Insert into a Nested List

The S2 solution must implement:

- `my-length`
- `my-map`
- `make-inserter`
- `insert-if-short`
- `print-insert-result`

Review requirements:

- Calculate the original top-level length of each list.
- Recursively process every nested list.
- Process empty lists using the same length condition.
- Insert the atom at the front only when the predicate succeeds.
- Use `make-inserter` in the final single definition of `insert-if-short`.
- Read `x`, `lst`, and `n` in that order.
- Print only the resulting list and a newline.

## 6. Testing

For both problems:

- Test the examples supplied in the assignment.
- Test empty inputs and boundary cases.
- Test multiple levels of nesting or tree depth.
- Test large inputs where practical.
- Verify exact output formatting.
- Keep test expressions separate from the submitted implementation.

For S2, specifically test:
- Empty top-level lists.
- Empty nested lists.
- Lists shorter than the threshold.
- Lists equal to the threshold.
- Lists longer than the threshold.
- Nesting depth 100.
- Lists containing 10,000 elements.

## 7. Self-Review Checklist

Before finalizing any Scheme solution:

- Does the file begin with `#lang racket/base`?
- Are only permitted built-ins used?
- Are all required functions defined?
- Are recursive cases handled correctly?
- Are empty structures handled correctly?
- Is element order preserved?
- Is tail recursion used where practical?
- Does loading the source file produce no output?
- Are there no top-level test calls?
- Does the implementation follow the exact assignment requirements?

## 8. Common Failure Modes

- Accidentally using prohibited built-ins such as `map` or `length`.
- Forgetting to handle empty lists or empty trees.
- Incorrect recursion through nested lists or subtrees.
- Reversing the required traversal order.
- Calculating list length after insertion instead of before it.
- Failing to preserve element order when using accumulators.
- Printing debugging information.
- Leaving test calls in the submitted implementation.
- Using functions that are available in Racket but not permitted by the assignment.
