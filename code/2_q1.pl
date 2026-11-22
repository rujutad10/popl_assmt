
:- use_module(library(lists)).

% Each friend is represented as:
% p(Name, Department, Language, Project)

names(['Alex', 'Ben', 'Carla', 'Dana']).

departments([research, development, design, testing]).
languages([python, java, 'c++', javascript]).
projects(['AI', web, embedded, data]).

% Generate every possible assignment.
assignment(Solution) :-
    departments(Departments),
    languages(Languages),
    projects(Projects),
    permutation(Departments, [D1,D2,D3,D4]),
    permutation(Languages, [L1,L2,L3,L4]),
    permutation(Projects, [P1,P2,P3,P4]),
    Solution = [
        p('Alex',D1,L1,P1),
        p('Ben',D2,L2,P2),
        p('Carla',D3,L3,P3),
        p('Dana',D4,L4,P4)
    ].

% Clue 1
clue(1, S) :-
    member(p(Name,Dept,_,'AI'), S),
    Dept \= research,
    Name \= 'Dana'.

% Clue 2: both exclusions must hold independently.
clue(2, S) :-
    member(p('Alex',Dept,Lang,_), S),
    Dept \= development,
    Lang \= 'c++'.

% Clue 3
clue(3, S) :-
    member(p(_,testing,python,_), S).

% Clue 4
clue(4, S) :-
    member(p('Ben',Dept,_,web), S),
    Dept \= testing.

% Clue 5
clue(5, S) :-
    member(p(_,design,java,_), S).

% Clue 6
clue(6, S) :-
    member(p('Carla',Dept,_,Project), S),
    Project \= embedded,
    Dept \= development.

% Clue 7
clue(7, S) :-
    member(p('Dana',Dept,Lang,_), S),
    Lang \= java,
    member(Dept,[research,testing]).

% Clue 8
clue(8, S) :-
    member(p(_,research,Lang,data), S),
    Lang \= javascript.

% CLUE 9: The friend who prefers the AI project likes Python.
clue(9, S) :-
    member(p(_,_,python,'AI'), S).

% Apply only the selected clues.
satisfies([], _).
satisfies([N|Rest], Solution) :-
    clue(N, Solution),
    satisfies(Rest, Solution).

% Generate solutions satisfying selected clues.
solution_for(Active, Solution) :-
    assignment(Solution),
    satisfies(Active, Solution).

% P1.a
solve(Solution) :-
    solution_for([1,2,3,4,5,6,7,8], Solution).

% Count all valid assignments.
% P1.b
count_solutions(Active, N) :-
    findall(S, solution_for(Active,S), Solutions),
    length(Solutions,N).

% P1.c: reports the count after adding clue 9 (exactly one solution).
repair(N) :-
    count_solutions([1,2,3,4,5,6,7,8,9], N).

% Print one friend per line.
print_solution([]).
print_solution([p(Name,Dept,Lang,Project)|Rest]) :-
    format('~w = [~w, ~w, ~w]~n',
           [Name,Dept,Lang,Project]),
    print_solution(Rest).

main :-
    once(solve(Solution)),
    print_solution(Solution).
