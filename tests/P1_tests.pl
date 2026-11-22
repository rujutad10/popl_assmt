% Run from the repository root:
% swipl -q -s tests/P1_tests.pl -g run_tests -t halt
:- ensure_loaded('../code/2_q1.pl').

:- begin_tests(p1).

% Expected results independently enumerated with Python permutations and
% Boolean translations of the English clues, rather than clue/2 calls.
single_clue_count(1, 7776).
single_clue_count(2, 7776).
single_clue_count(3, 3456).
single_clue_count(4, 2592).
single_clue_count(5, 3456).
single_clue_count(6, 7776).
single_clue_count(7, 5184).
single_clue_count(8, 2592).
single_clue_count(9, 3456).

omitted_clue_count(1, 4).
omitted_clue_count(2, 6).
omitted_clue_count(3, 13).
omitted_clue_count(4, 12).
omitted_clue_count(5, 9).
omitted_clue_count(6, 7).
omitted_clue_count(7, 5).
omitted_clue_count(8, 16).

expected_solution([
    p('Alex', design, java, 'AI'),
    p('Ben', development, javascript, web),
    p('Carla', research, 'c++', data),
    p('Dana', testing, python, embedded)
]).
expected_solution([
    p('Alex', design, java, embedded),
    p('Ben', development, javascript, web),
    p('Carla', testing, python, 'AI'),
    p('Dana', research, 'c++', data)
]).
expected_solution([
    p('Alex', testing, python, embedded),
    p('Ben', development, javascript, web),
    p('Carla', design, java, 'AI'),
    p('Dana', research, 'c++', data)
]).

test(clue2_rejects_development_without_cpp) :-
    S = [p('Alex', development, python, _) | _],
    once(assignment(S)),
    assertion(\+ clue(2, S)).

test(clue2_rejects_cpp_outside_development) :-
    S = [p('Alex', research, 'c++', _) | _],
    once(assignment(S)),
    assertion(\+ clue(2, S)).

test(clue2_rejects_both_forbidden_attributes) :-
    S = [p('Alex', development, 'c++', _) | _],
    once(assignment(S)),
    assertion(\+ clue(2, S)).

test(clue2_accepts_both_exclusions) :-
    S = [p('Alex', design, java, _) | _],
    once(assignment(S)),
    assertion(clue(2, S)).

test(unconstrained_count) :-
    count_solutions([], N),
    assertion(N == 13824).  % (4!)^3

test(unconstrained_assignments_are_distinct) :-
    findall(S, assignment(S), All),
    sort(All, Unique),
    length(All, N),
    length(Unique, U),
    assertion(N == 13824),
    assertion(U == N).

test(all_assignments_have_exact_domains_and_name_order) :-
    forall(assignment(S), (
        S = [p('Alex',D1,L1,P1), p('Ben',D2,L2,P2),
             p('Carla',D3,L3,P3), p('Dana',D4,L4,P4)],
        msort([D1,D2,D3,D4], [design,development,research,testing]),
        msort([L1,L2,L3,L4], ['c++',java,javascript,python]),
        msort([P1,P2,P3,P4], ['AI',data,embedded,web])
    )).

test(each_clue_in_isolation,
     [forall(single_clue_count(Clue, Expected))]) :-
    count_solutions([Clue], Actual),
    assertion(Actual == Expected).

test(omit_each_original_clue,
     [forall(omitted_clue_count(Clue, Expected))]) :-
    once(select(Clue, [1,2,3,4,5,6,7,8], Active)),
    count_solutions(Active, Actual),
    assertion(Actual == Expected).

test(original_count) :-
    count_solutions([1,2,3,4,5,6,7,8], N),
    assertion(N == 3).

test(count_returns_exactly_one_answer) :-
    findall(N, count_solutions([1,2,3,4,5,6,7,8], N), Answers),
    assertion(Answers == [3]).

test(solve_enumerates_exactly_the_expected_solutions) :-
    findall(S, solve(S), Actual),
    findall(S, expected_solution(S), Expected),
    sort(Actual, SortedActual),
    sort(Expected, SortedExpected),
    assertion(SortedActual == SortedExpected),
    length(Actual, N),
    assertion(N == 3).

test(repair_has_one_solution) :-
    repair(N),
    assertion(N == 1).

test(repair_keeps_the_expected_solution) :-
    findall(S, solution_for([1,2,3,4,5,6,7,8,9], S), Actual),
    assertion(Actual == [[
        p('Alex', design, java, embedded),
        p('Ben', development, javascript, web),
        p('Carla', testing, python, 'AI'),
        p('Dana', research, 'c++', data)
    ]]).

test(clue9_filters_exactly_one_original_solution) :-
    findall(S, (solve(S), clue(9, S)), Kept),
    findall(S, (solve(S), \+ clue(9, S)), Rejected),
    length(Kept, K),
    length(Rejected, R),
    assertion(K == 1),
    assertion(R == 2).

test(active_order_is_irrelevant) :-
    count_solutions([8,7,6,5,4,3,2,1], N),
    assertion(N == 3).

test(repeating_a_clue_does_not_duplicate_solutions) :-
    count_solutions([1,2,3,4,5,6,7,8,2,9,9], N),
    assertion(N == 1).

test(unknown_clue_has_zero_solutions) :-
    count_solutions([99], N),
    assertion(N == 0).

test(main_prints_exactly_four_lines) :-
    with_output_to(string(Output), main),
    assertion(Output == "Alex = [design, java, AI]\nBen = [development, javascript, web]\nCarla = [research, c++, data]\nDana = [testing, python, embedded]\n").

test(main_has_exactly_one_success) :-
    findall(Output, with_output_to(string(Output), main), Outputs),
    assertion(Outputs == ["Alex = [design, java, AI]\nBen = [development, javascript, web]\nCarla = [research, c++, data]\nDana = [testing, python, embedded]\n"]).

:- end_tests(p1).
