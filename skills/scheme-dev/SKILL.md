
---
name: scheme-dev
description: Development and review instructions for Racket solutions in CS F301.
---

# Scheme Development Skill

## Language and Environment
- Use Racket 8.x.
- Every source file must begin with #lang racket/base.

## Allowed Constructs
- Follow the exact built-ins permitted in the assignment.
- S2 additionally allows read.
- Do not use forbidden functions such as length, map, append,
  reverse, filter, member, list-ref or list-tail.
- Do not use set! or other mutation.
- Do not use vectors, hash tables or imperative loops.

## Coding Conventions
- Use descriptive function names.
- Prefer recursion and named let.
- Pass state through function arguments.
- Preserve the original order of list elements.
- Add comments explaining important logic.

## Testing Guidelines
- Test empty lists.
- Test nested lists.
- Test empty nested lists.
- Test lists shorter than the threshold.
- Test lists equal to the threshold.
- Test lists longer than the threshold.
- Test large lists and deep nesting.

## Self-Review Checklist
- Does the code use only permitted built-ins?
- Are nested lists processed recursively?
- Are empty lists handled correctly?
- Is the original list length used for the condition?
- Is the original element order preserved?
- Does loading the file produce no output?
- Does print-insert-result read x, lst and n in order?
- Does the output end with a newline?

## Common AI Failure Modes
- Accidentally using forbidden built-ins.
- Forgetting to process nested lists.
- Ignoring empty nested lists.
- Checking the modified list length instead of the original length.
- Using mutation.
- Printing debugging messages.
- Defining insert-if-short more than once.
- Leaving test calls in the final implementation file.
