
:- use_module(library(lists)).

expr_tree([N], num(N)).
expr_tree(List, expr(Op, LeftTree, RightTree)) :-
    append(Left, Right, List),
    Left  = [_|_],
    Right = [_|_],
    member(Op, [+, -, *, /]),
    expr_tree(Left,  LeftTree),
    expr_tree(Right, RightTree).
eval_expr(num(N), N).

eval_expr(expr(+, L, R), V) :-
    eval_expr(L, A),
    eval_expr(R, B),
    V is A + B.

eval_expr(expr(-, L, R), V) :-
    eval_expr(L, A),
    eval_expr(R, B),
    V is A - B.

eval_expr(expr(*, L, R), V) :-
    eval_expr(L, A),
    eval_expr(R, B),
    V is A * B.

eval_expr(expr(/, L, R), V) :-
    eval_expr(L, A),
    eval_expr(R, B),
    B =\= 0,
    A mod B =:= 0,
    V is A // B.
% Precedence table: higher number binds tighter.
op_prec(+, 1).
op_prec(-, 1).
op_prec(*, 2).
op_prec(/, 2).


% format_expr(+Tree, +ParentOp, +Side, -String)

format_expr(num(N), _, _, String) :-
    format(string(String), "~d", [N]).

format_expr(expr(Op, L, R), ParentOp, Side, String) :-
    format_expr(L, Op, left,  LS),
    format_expr(R, Op, right, RS),
    format(string(Bare), "~s~a~s", [LS, Op, RS]),
    (   ParentOp \== none,
        op_prec(Op, C),
        op_prec(ParentOp, P),
        (   Side == left
        ->  C < P
        ;   C =< P
        )
    ->  format(string(String), "(~s)", [Bare])
    ;   String = Bare
    ).
equation_for_split(List, Equation) :-
    append(Left, Right, List),
    Left  = [_|_],
    Right = [_|_],
    expr_tree(Left,  LeftTree),
    expr_tree(Right, RightTree),
    eval_expr(LeftTree,  LeftValue),
    eval_expr(RightTree, RightValue),
    LeftValue =:= RightValue,
    format_expr(LeftTree,  none, left, LeftString),
    format_expr(RightTree, none, left, RightString),
    format(string(Equation), "~s=~s", [LeftString, RightString]).
generate_equation(List, Equation) :-
    once(equation_for_split(List, Equation)).
all_equations(List, Equations) :-
    findall(E, equation_for_split(List, E), Found),
    sort(Found, Equations).
count_equations(List, N) :-
    all_equations(List, Equations),
    length(Equations, N).