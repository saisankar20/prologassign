:- [adts].

less_than_or_equals(A, B) :- A =< B.
greater_than_or_equals(A, B) :- A >= B.
equals(A, B) :- A is B.

move(state(Row, Column), state(Newrow, Newcolumn)) :-
    less_than_or_equals(Row, 6),
    equals(Newrow, Row + 2),
    less_than_or_equals(Column, 7),
    equals(Newcolumn, Column + 1).

move(state(Row, Column), state(Newrow, Newcolumn)) :-
    less_than_or_equals(Row, 7),
    equals(Newrow, Row + 1),
    less_than_or_equals(Column, 6),
    equals(Newcolumn, Column + 2).

move(state(Row, Column), state(Newrow, Newcolumn)) :-
    less_than_or_equals(Row, 6),
    equals(Newrow, Row + 2),
    greater_than_or_equals(Column, 2),
    equals(Newcolumn, Column - 1).

move(state(Row, Column), state(Newrow, Newcolumn)) :-
    less_than_or_equals(Row, 7),
    equals(Newrow, Row + 1),
    greater_than_or_equals(Column, 3),
    equals(Newcolumn, Column - 2).

move(state(Row, Column), state(Newrow, Newcolumn)) :-
    greater_than_or_equals(Row, 3),
    equals(Newrow, Row - 2),
    less_than_or_equals(Column, 7),
    equals(Newcolumn, Column + 1).

move(state(Row, Column), state(Newrow, Newcolumn)) :-
    greater_than_or_equals(Row, 2),
    equals(Newrow, Row - 1),
    less_than_or_equals(Column, 6),
    equals(Newcolumn, Column + 2).

move(state(Row, Column), state(Newrow, Newcolumn)) :-
    greater_than_or_equals(Row, 3),
    equals(Newrow, Row - 2),
    greater_than_or_equals(Column, 2),
    equals(Newcolumn, Column - 1).

move(state(Row, Column), state(Newrow, Newcolumn)) :-
    greater_than_or_equals(Row, 2),
    equals(Newrow, Row - 1),
    greater_than_or_equals(Column, 3),
    equals(Newcolumn, Column - 2).

% Define the initial and goal states
initial_state(state(1,1)).
goal_state(state(8,8)).

% Depth-first search with output
dfs(Start, Goal) :-
    dfs_helper(Start, Goal, [Start], Path),
    reverse(Path, ReversedPath),
    print_path(ReversedPath).

dfs_helper(Current, Goal, _, [Goal|Rest]) :- % We reached the goal state
    goal_state(Current),
    Current = Goal,
    reverse(Rest, _).