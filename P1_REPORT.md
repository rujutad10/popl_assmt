# P1 Report — Group 2

## P1.a — Representation and solver

Each assignment is a list of four `p(Name, Department, Language, Project)`
terms, in the order Alex, Ben, Carla, Dana. Independently permuting the four
department, language, and project values uses every value exactly once.
There are `(4!)^3 = 13824` assignments before applying clues.

`clue/2` checks each numbered clue on a fully instantiated assignment.
`solve/1` applies clues 1–8, and `main/0` prints the first resulting solution
in the required four-line format. The solution is generated, not hard-coded.

## P1.b — Solution count

```prolog
?- count_solutions([1,2,3,4,5,6,7,8], N).
N = 3.
```

The puzzle is consistent but underdetermined: the eight original clues admit
three distinct solutions rather than a unique assignment. `count_solutions/2`
uses `findall/3` and counts only assignments satisfying the selected clues.
An empty clue list gives 13824, since no clues are applied.

All three solutions are shown below. Each cell lists department, language,
and project, in that order.

| Solution | Alex | Ben | Carla | Dana |
| --- | --- | --- | --- | --- |
| 1 | design, java, AI | development, javascript, web | research, c++, data | testing, python, embedded |
| 2 | design, java, embedded | development, javascript, web | testing, python, AI | research, c++, data |
| 3 | testing, python, embedded | development, javascript, web | design, java, AI | research, c++, data |

## P1.c — Ninth clue and uniqueness

**The friend who prefers the AI project likes Python.**

```prolog
% CLUE 9: The friend who prefers the AI project likes Python.
clue(9, S) :-
    member(p(_,_,python,'AI'), S).
```

This clue refers only to attributes and mentions no friend by name. It is
true in solution 2 and false in solutions 1 and 3, where the AI project is
paired with Java. Thus it keeps exactly one of the original solutions:

```prolog
?- count_solutions([1,2,3,4,5,6,7,8,9], N).
N = 1.
```

The unique repaired assignment is:

```text
Alex = [design, java, embedded]
Ben = [development, javascript, web]
Carla = [testing, python, AI]
Dana = [research, c++, data]
```

`main/0` continues to solve the original eight-clue puzzle, as required by
P1.a. To enumerate repaired solutions, use
`solution_for([1,2,3,4,5,6,7,8,9], S)`.

## Correction to the earlier draft

Clue 2 says Alex does not work in development **and** does not prefer C++.
It therefore requires two exclusions:

```prolog
Dept \= development,
Lang \= 'c++'.
```

The earlier expression `\+ (Dept = development, Lang = 'c++')` rejected only
the combination of development and C++, allowing either forbidden attribute
on its own. That error produced six assignments. With the correct clue,
there are three. The earlier draft's claim that repair is impossible is
also incorrect: although solutions 1 and 3 have the same attribute
combinations assigned to different friends, solution 2 has a different
combination and can be isolated by the ninth clue above.

## Verification and commands

Validated using SWI-Prolog 9.2.9 on Windows. All 35 test cases pass, covering
the two separate exclusions in clue 2, each clue in isolation, omission of
each original clue, all original solutions, uniqueness after repair,
duplicate-free generation, clue ordering, repeated clues, zero solutions
for an unknown clue, exact attribute domains and name order for every
assignment, deterministic counting, and exact `main/0` output with one
successful result.

An independent Python enumeration of all 13824 assignments, using Boolean
translations of the English clues, confirmed the three solutions, the
repaired solution, and all single-clue and omitted-clue counts used in the
tests. A subsequent exhaustive comparison also verified the truth value
of each of the nine clues on every assignment: 124416 individual checks,
all matching the independent English-clue translations.
The program loads silently, uses only the allowed `lists` library,
and contains no initialization directive or call to `halt/0`.

## Review against the eight supplied prompts
| Prompt | Review result |
| --- | --- |
| 1 — Representation | Correct: exactly four friends in the required order, with each attribute value used once. |
| 2 — Clues | All eight original clauses match the English clues, including both separate exclusions in clue 2. |
| 3 — Solver | Correct: enumerates exactly the three original solutions without duplicates or hard-coded answers. |
| 4 — Output | Correct: `main/0` succeeds once and prints exactly four correctly formatted lines. Loading the file produces no output. |
| 5 — Counting | Correct: uses `findall/3`, applies only selected clues, returns 13824 with no clues and 3 with clues 1–8. |
| 6 — Ninth clue | Valid: the sentence mentions only attributes and selects exactly one original solution. |
| 7 — Repair | The prompt names `repair/2`, but the code defines the optional `repair/1` count helper. The PDF requires `clue(9, Solution)` and a count of 1 with clues 1–9; it does not prescribe any `repair/2` interface. Both required behaviors pass. |
| 8 — Tests | All 35 test cases pass, including three additional cases for representation invariants and single-result behavior. |

From the repository root in PowerShell:

```powershell
& 'C:\Program Files\swipl\bin\swipl.exe' -q -f code/10_q1.pl -g main -t halt
& 'C:\Program Files\swipl\bin\swipl.exe' -q -f code/10_q1.pl -g 'count_solutions([1,2,3,4,5,6,7,8],N),writeln(N)' -t halt
& 'C:\Program Files\swipl\bin\swipl.exe' -q -f code/10_q1.pl -g 'count_solutions([1,2,3,4,5,6,7,8,9],N),writeln(N)' -t halt
& 'C:\Program Files\swipl\bin\swipl.exe' -q -s tests/P1_tests.pl -g run_tests -t halt
```
