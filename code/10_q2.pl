:- use_module(library(lists)).

% ===== Expression trees: num(N) is a leaf, expr(Op, L, R) is an operation =====

% expr_tree(+List, -Tree): every tree over List, numbers kept in order
expr_tree([N], num(N)).
expr_tree(List, expr(Op, LeftTree, RightTree)) :-
    % cut the list into a non-empty left part and right part
    append(Left, Right, List),
    Left  = [_|_],
    Right = [_|_],
    % try each operator, then build trees for both parts
    member(Op, [+, -, *, /]),
    expr_tree(Left,  LeftTree),
    expr_tree(Right, RightTree).


% ===== Evaluation: fails if any division is invalid =====

% eval_expr(+Tree, -Value)
% a number is its own value
eval_expr(num(N), N).

% evaluate both sides, then add
eval_expr(expr(+, L, R), V) :-
    eval_expr(L, A),
    eval_expr(R, B),
    V is A + B.

% evaluate both sides, then subtract
eval_expr(expr(-, L, R), V) :-
    eval_expr(L, A),
    eval_expr(R, B),
    V is A - B.

% evaluate both sides, then multiply
eval_expr(expr(*, L, R), V) :-
    eval_expr(L, A),
    eval_expr(R, B),
    V is A * B.

% divide only if divisor is not zero and the division is exact
eval_expr(expr(/, L, R), V) :-
    eval_expr(L, A),
    eval_expr(R, B),
    B =\= 0,
    A mod B =:= 0,
    V is A // B.


% ===== Formatting: canonical string with minimal parentheses =====

% op_prec(+Op, -Level): higher level binds tighter
op_prec(+, 1).
op_prec(-, 1).
op_prec(*, 2).
op_prec(/, 2).

% format_expr(+Tree, +ParentOp, +Side, -String)
% a number is never put in parentheses
format_expr(num(N), _, _, String) :-
    format(string(String), "~d", [N]).

format_expr(expr(Op, L, R), ParentOp, Side, String) :-
    % format both children first
    format_expr(L, Op, left,  LS),
    format_expr(R, Op, right, RS),
    % join them with the operator, no spaces
    format(string(Bare), "~s~a~s", [LS, Op, RS]),
    % wrap in parentheses only if the parent needs it
    (   ParentOp \== none,
        op_prec(Op, C),
        op_prec(ParentOp, P),
        (   Side == left
        ->  C < P       % left child: only if it binds looser
        ;   C =< P      % right child: if it binds looser or equal
        )
    ->  format(string(String), "(~s)", [Bare])
    ;   String = Bare
    ).


% ===== One equation for each split of the list =====

% equation_for_split(+List, -Equation)
equation_for_split(List, Equation) :-
    % pick a split with both sides non-empty
    append(Left, Right, List),
    Left  = [_|_],
    Right = [_|_],
    % build a tree for each side
    expr_tree(Left,  LeftTree),
    expr_tree(Right, RightTree),
    % keep only pairs with valid and equal values
    eval_expr(LeftTree,  LeftValue),
    eval_expr(RightTree, RightValue),
    LeftValue =:= RightValue,
    % print both sides and join with '='
    format_expr(LeftTree,  none, left, LeftString),
    format_expr(RightTree, none, left, RightString),
    format(string(Equation), "~s=~s", [LeftString, RightString]).


% ===== Public predicates =====

% generate_equation(+List, -Equation): first valid equation, fails if none
generate_equation(List, Equation) :-
    once(equation_for_split(List, Equation)).

% all_equations(+List, -Equations): all valid equations, sorted, no duplicates
all_equations(List, Equations) :-
    findall(E, equation_for_split(List, E), Found),
    sort(Found, Equations).

% count_equations(+List, -N): how many distinct equations exist
count_equations(List, N) :-
    all_equations(List, Equations),
    length(Equations, N).