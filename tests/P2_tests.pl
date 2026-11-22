% ---------------------------------------------------------------------------
% P2 test file (separate from the solution).
% Replace `id_q2` below with your real file name (path is relative to this file).
% ---------------------------------------------------------------------------
:- consult('../code/2_q2').
:- discontiguous p2_test/2.

% ===========================================================================
% Independent oracle (written from the SPEC, not from your helpers)
% ===========================================================================

% Evaluate a term parsed from an equation side, with exact division only.
t_eval(N, N) :- integer(N), !.
t_eval(T, V) :- T =.. [Op, L, R], t_eval(L, A), t_eval(R, B), t_apply(Op, A, B, V).

t_apply(+, A, B, V) :- V is A + B.
t_apply(-, A, B, V) :- V is A - B.
t_apply(*, A, B, V) :- V is A * B.
t_apply(/, A, B, V) :- B =\= 0, A mod B =:= 0, V is A // B.

% Canonical printer written directly from the spec's parenthesisation rule.
t_prec(+, 1).  t_prec(-, 1).  t_prec(*, 2).  t_prec(/, 2).

t_render(N, S) :- integer(N), !, format(string(S), "~d", [N]).
t_render(T, S) :-
    T =.. [Op, L, R], t_prec(Op, P),
    t_side(L, left,  P, LS),
    t_side(R, right, P, RS),
    format(string(S), "~w~w~w", [LS, Op, RS]).

t_side(T, Side, P, S) :-
    t_render(T, S0),
    (   t_wrap(T, Side, P) -> format(string(S), "(~w)", [S0]) ; S = S0 ).

t_wrap(T, Side, P) :-
    compound(T), T =.. [Op, _, _], t_prec(Op, C),
    (   Side == left -> C < P ; C =< P ).

% Status of a goal: true / false / error(E). Lets us check "fails, never throws".
t_status(Goal, S) :-
    catch(( call(Goal) -> S = true ; S = false ), error(E, _), S = error(E)).

% ===========================================================================
% Helpers used by the tests
% ===========================================================================
t_all_exact(L, Exp) :- all_equations(L, Es), Es == Exp.        % exact order
t_all_is(L, Exp)    :- all_equations(L, Es), sort(Exp, S), Es == S.
t_has(L, E)         :- all_equations(L, Es), memberchk(E, Es).
t_lacks(L, E)       :- all_equations(L, Es), \+ memberchk(E, Es).
t_none(L) :-
    t_all_exact(L, []),
    t_status(generate_equation(L, _), false),
    count_equations(L, 0).

% Lists used by the property tests (results NOT hard-coded; checked by oracle).
t_prop_list([4,2,5,3]).   t_prop_list([2,4,8]).     t_prop_list([2,3,4]).
t_prop_list([8,4,2]).     t_prop_list([0,0]).       t_prop_list([0,0,0]).
t_prop_list([0,5,0]).     t_prop_list([5,0,0]).     t_prop_list([3,1,1,1]).
t_prop_list([1,1,1]).     t_prop_list([10,2,5]).    t_prop_list([3,5,4,6]).
t_prop_list([7,2,2,7]).   t_prop_list([2,5,3,0,1]). t_prop_list([5,3,0,2]).
t_prop_list([1,2,3,6]).   t_prop_list([1,2,3,4,5]). t_prop_list([1,2,3,4,5,6]).
t_prop_list([]).          t_prop_list([5]).         t_prop_list([1,2]).

t_each_list(Check) :-
    forall(t_prop_list(L),
           (   call(Check, L) -> true
           ;   format("  offending list: ~w~n", [L]), fail )).

t_each_eq(L, Check) :-
    all_equations(L, Es),
    forall(member(E, Es),
           (   call(Check, L, E) -> true
           ;   format("  offending equation: ~q~n", [E]), fail )).

% ----- per-equation checks -------------------------------------------------
t_is_string(_, E)  :- string(E), \+ is_list(E).
t_one_eq(_, E)     :- split_string(E, "=", "", Parts), length(Parts, 2).
t_sides(_, E)      :- split_string(E, "=", "", [A, B]), A \== "", B \== "".
t_no_space(_, E)   :- \+ sub_string(E, _, _, _, " ").
t_chars(_, E) :-
    atom_chars('0123456789+-*/()=', Allowed),
    string_chars(E, Cs), forall(member(C, Cs), memberchk(C, Allowed)).
t_numbers(L, E) :-          % numbers appear once each, in original order
    split_string(E, "=+-*/()", "", Parts),
    exclude(==(""), Parts, Toks),
    maplist(number_string, L, Exp),
    Toks == Exp.
t_oracle_valid(_, E) :-     % sides equal, all divisions exact and non-zero
    term_string(T, E), T = (LT = RT),
    t_eval(LT, V), t_eval(RT, V).
t_canonical(_, E) :-        % printed form equals spec's canonical form of its parse
    term_string(T, E), T = (LT = RT),
    t_render(LT, LS), t_render(RT, RS),
    format(string(E2), "~w=~w", [LS, RS]),
    E2 == E.
t_no_div_zero(_, E) :- \+ sub_string(E, _, _, _, "/0").

% ===========================================================================
% Runner
% ===========================================================================
run_p2_tests :-
    findall(N, p2_test(N, _), All), length(All, Total),
    findall(N, ( p2_test(N, G), \+ t_passes(G) ), Failed),
    forall(member(N, Failed), format("FAIL: ~w~n", [N])),
    length(Failed, F), Passed is Total - F,
    format("~d/~d tests passed~n", [Passed, Total]),
    Failed == [].

t_passes(G) :-
    catch(once(G), Err, ( format("  exception: ~q~n", [Err]), fail )).

% ===========================================================================
% TESTS.  p2_test(Name, Goal).  Comment above each = bug it detects.
% ===========================================================================

% --- 1. Spec example [4,2,5,3] ---------------------------------------------
% Missing trees/splits, wrong parentheses, wrong sort order, duplicates.
p2_test(ex1_all_exact_spec_list,
    t_all_exact([4,2,5,3],
        ["4*2-5=3","4*2=5+3","4-2=5-3","4/2=5-3",
         "4=2*(5-3)","4=2+(5-3)","4=2+5-3"])).
% count not equal to 7 (e.g. counting raw findall results, or off-by-one splits).
p2_test(ex1_count, count_equations([4,2,5,3], 7)).
% generate_equation returning something outside the valid set, or a non-string.
p2_test(ex1_generate_in_set,
    ( generate_equation([4,2,5,3], E),
      memberchk(E, ["4*2-5=3","4*2=5+3","4-2=5-3","4/2=5-3",
                    "4=2*(5-3)","4=2+(5-3)","4=2+5-3"]) )).
% generate_equation leaving choice points (should be deterministic via once/1).
p2_test(ex1_generate_deterministic,
    ( findall(E, generate_equation([4,2,5,3], E), Es), length(Es, 1) )).

% --- 2. Spec example [2,3,4] (no solution) ---------------------------------
% generate_equation succeeding/looping/throwing; all_equations failing instead of [].
p2_test(ex2_no_solution, t_none([2,3,4])).

% --- 3. Spec example [2,4,8] -----------------------------------------------
% Extra bogus equations (e.g. "2+4=8"); count wrong; wrong string format.
p2_test(ex3_all, t_all_exact([2,4,8], ["2*4=8"])).
p2_test(ex3_generate, generate_equation([2,4,8], "2*4=8")).
p2_test(ex3_count, count_equations([2,4,8], 1)).

% --- 4. Empty input --------------------------------------------------------
% Error/loop on [], or generate_equation succeeding.
p2_test(empty_input, t_none([])).

% --- 5. Single element -----------------------------------------------------
% Allowing an empty side ("5=" or "=5"), crash on singleton.
p2_test(single_5, t_none([5])).
p2_test(single_0, t_none([0])).

% --- 6. Two-element inputs -------------------------------------------------
% Missing the only split, or accepting unequal numbers.
p2_test(two_equal,      t_all_exact([3,3], ["3=3"])).
p2_test(two_equal_gen,  generate_equation([4,4], "4=4")).
p2_test(two_equal_cnt,  count_equations([4,4], 1)).
p2_test(two_unequal_1_2, t_none([1,2])).
p2_test(two_unequal_5_7, t_none([5,7])).
p2_test(two_zero_vs_5,   t_none([0,5])).

% --- 7. Inputs containing zero ---------------------------------------------
% 0/0 accepted (or error); 0+0, 0-0, 0*0 missed; wrong split handling.
% [0,0,0]: 0=0+0, 0=0-0, 0=0*0 and the three mirrored forms; 0/0 is invalid.
p2_test(zero_three,
    t_all_is([0,0,0],
        ["0=0+0","0=0-0","0=0*0","0+0=0","0-0=0","0*0=0"])).
p2_test(zero_three_count, count_equations([0,0,0], 6)).
p2_test(zero_two, t_all_exact([0,0], ["0=0"])).
% [5,0,0]: only 5*0=0 works (5/0 invalid, 5+0 and 5-0 give 5).
p2_test(zero_five_zero_zero, t_all_exact([5,0,0], ["5*0=0"])).

% --- 8. Exact division -----------------------------------------------------
% Exact division rejected or truncated incorrectly.
p2_test(exact_8_4_2, t_all_exact([8,4,2], ["8/4=2","8=4*2"])).
p2_test(exact_8_4_2_count, count_equations([8,4,2], 2)).
% Multi-digit numbers kept whole and 10/2 accepted.
p2_test(exact_10_2_5, t_all_exact([10,2,5], ["10/2=5","10=2*5"])).
% 0 divided by non-zero is valid (0/5 = 0): tests the guard is not "A > 0".
p2_test(exact_zero_numerator, t_all_is([0,5,0], ["0*5=0","0/5=0","0=5*0"])).
p2_test(exact_in_spec, t_has([4,2,5,3], "4/2=5-3")).

% --- 9. Division by zero must be rejected ----------------------------------
% Raising an arithmetic exception instead of failing, or accepting x/0.
p2_test(divzero_no_error_5_0_0, t_status(all_equations([5,0,0], _), true)).
p2_test(divzero_no_error_gen,   t_status(generate_equation([5,0,0], _), true)).
p2_test(divzero_no_error_0_0_0, t_status(generate_equation([0,0,0], _), true)).
% [6,0,3]: only candidates involve 6/0 or sums/products unequal to the other side.
p2_test(divzero_nothing_valid, t_none([6,0,3])).
% No equation for any property list may contain a literal zero divisor.
p2_test(divzero_never_in_output, t_each_list(t_p_no_div_zero)).
t_p_no_div_zero(L) :- t_each_eq(L, t_no_div_zero).

% --- 10. Division that is not exact ----------------------------------------
% Truncating division accepted (7/2=3) or float arithmetic (7/2*2 = 7.0).
p2_test(inexact_trunc_7_2_3, t_none([7,2,3])).
p2_test(inexact_trunc_5_2_2, t_none([5,2,2])).
% Float trap: 7/2*2 equals 7 only in floats; must not appear.
p2_test(inexact_float_trap_absent, t_lacks([7,2,2,7], "7/2*2=7")).
% Valid exact variants of the same numbers must still be found.
p2_test(inexact_float_trap_valid_1, t_has([7,2,2,7], "7/(2/2)=7")).
p2_test(inexact_float_trap_valid_2, t_has([7,2,2,7], "7*2/2=7")).

% --- 11. Negative intermediate values --------------------------------------
% Rejecting negatives or mis-evaluating them (3-5 = -2 on both sides).
p2_test(negative_both_sides, t_has([3,5,4,6], "3-5=4-6")).
% Exact division of a negative value: (2-5)/3 = -1 = 0-1.
p2_test(negative_exact_division, t_has([2,5,3,0,1], "(2-5)/3=0-1")).

% --- 12. Several valid trees for the same numbers --------------------------
% Missing alternative groupings.
p2_test(multi_three_ones,
    t_all_is([1,1,1], ["1=1*1","1=1/1","1*1=1","1/1=1"])).
p2_test(multi_three_ones_count, count_equations([1,1,1], 4)).
p2_test(multi_3_1_1_1_both,
    ( t_has([3,1,1,1], "3=1+(1+1)"), t_has([3,1,1,1], "3=1+1+1") )).

% --- 13. Different trees must print as different strings -------------------
% Same value but different tree must not collapse (dedupe too aggressive)
% and parentheses must follow the right-operand rule.
p2_test(distinct_plus_assoc,
    ( t_has([1,2,3,6], "1+(2+3)=6"), t_has([1,2,3,6], "1+2+3=6") )).
p2_test(distinct_minus_assoc,
    ( t_has([5,3,0,2], "5-3-0=2"), t_has([5,3,0,2], "5-(3-0)=2") )).
p2_test(distinct_spec_pair,
    ( t_has([4,2,5,3], "4=2+(5-3)"), t_has([4,2,5,3], "4=2+5-3") )).
% Left-associative output must not gain redundant parentheses.
p2_test(distinct_no_redundant_parens,
    t_lacks([5,3,0,2], "(5-3)-0=2")).

% ===========================================================================
% PROPERTIES over many lists (each list in t_prop_list/1)
% ===========================================================================

% Every equation is an SWI-Prolog string (not atom / code list).
p2_test(prop_strings,       t_each_list(t_p_strings)).
t_p_strings(L)       :- t_each_eq(L, t_is_string).

% Exactly one '=' in each equation.
p2_test(prop_one_equals,    t_each_list(t_p_one_eq)).
t_p_one_eq(L)        :- t_each_eq(L, t_one_eq).

% Neither side of '=' is empty.
p2_test(prop_nonempty_sides, t_each_list(t_p_sides)).
t_p_sides(L)         :- t_each_eq(L, t_sides).

% No spaces and only digits, + - * / ( ) = appear.
p2_test(prop_no_spaces,     t_each_list(t_p_no_space)).
t_p_no_space(L)      :- t_each_eq(L, t_no_space).
p2_test(prop_allowed_chars, t_each_list(t_p_chars)).
t_p_chars(L)         :- t_each_eq(L, t_chars).

% Every number used exactly once, original order (no permutation, no
% digit-joining, no dropped/duplicated numbers).
p2_test(prop_numbers_in_order, t_each_list(t_p_numbers)).
t_p_numbers(L)       :- t_each_eq(L, t_numbers).

% Every returned equation is truly valid (equal sides, exact non-zero division),
% checked by an independent evaluator on the parsed string.
p2_test(prop_oracle_valid,  t_each_list(t_p_valid)).
t_p_valid(L)         :- t_each_eq(L, t_oracle_valid).

% Parenthesisation is exactly the spec's canonical form (no missing or
% redundant parentheses, wrong left/right asymmetry).
p2_test(prop_canonical_form, t_each_list(t_p_canon)).
t_p_canon(L)         :- t_each_eq(L, t_canonical).

% all_equations returns no duplicates and is sort/2-ordered (sort/2 output
% is both sorted and duplicate-free, so equality with its own sort proves both).
p2_test(prop_sorted_unique, t_each_list(t_p_sorted)).
t_p_sorted(L) :-
    all_equations(L, Es), sort(Es, S), Es == S,
    length(Es, N), length(S, N).

% all_equations always succeeds with a proper list (never fails or throws).
p2_test(prop_all_total, t_each_list(t_p_total)).
t_p_total(L) :- t_status(all_equations(L, Es), true), all_equations(L, Es), is_list(Es).

% count_equations equals the number of equations returned.
p2_test(prop_count_matches, t_each_list(t_p_count)).
t_p_count(L) :-
    all_equations(L, Es), length(Es, N), count_equations(L, N),
    findall(M, count_equations(L, M), [_]).

% generate_equation: succeeds iff all_equations is non-empty, returns a member,
% is deterministic, and fails cleanly (no exception) otherwise.
p2_test(prop_generate_consistent, t_each_list(t_p_generate)).
t_p_generate(L) :-
    all_equations(L, Es),
    (   Es == []
    ->  t_status(generate_equation(L, _), false)
    ;   findall(E, generate_equation(L, E), [G]),
        string(G), memberchk(G, Es)
    ).