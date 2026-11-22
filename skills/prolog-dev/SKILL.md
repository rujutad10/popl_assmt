
---
name: prolog-dev
description: Guidelines for developing and testing Prolog programs for CS F301 POPL Assignment 2.
---

# Prolog Development Skill

## Environment
- SWI-Prolog 9.2.9
- Windows PowerShell
- Source extension: .pl

## Coding Standards
- Use lowercase predicate names.
- Use uppercase names for variables.
- Prefer declarative programming.
- Use helper predicates for separate constraints.
- Avoid unnecessary cuts.
- Do not hard-code expected solutions.
- Preserve the required predicate interfaces.

## Running Programs

Load a file:

    swipl -q -s code/10_q1.pl

Execute a goal:

    swipl -q -s code/10_q1.pl -g "Goal" -t halt

## Testing
- Verify all assignment examples.
- Test multiple and zero solution cases.
- Check for duplicate solutions.
- Check correct backtracking.
- Check exact output formatting.
- Test invalid and boundary inputs.

## Common AI Failure Modes
- Incorrect variable unification.
- Unintended extra solutions.
- Missing base cases.
- Incorrect negation.
- Hard-coded solutions.
- Incorrect predicate arity.
- Infinite recursion.

## Final Verification
- Confirm compatibility with SWI-Prolog 9.x.
- Confirm all required predicates exist.
- Verify expected outputs.
- Ensure all assignment restrictions are followed.
