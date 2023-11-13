% Modify the "move" predicate based on the provided rules
move(square(Row, Column), square(Newrow, Newcolumn)) :-
    Row =< 6,
    Newrow is Row + 2,
    Column =< 7,
    Newcolumn is Column + 1.

move(square(Row, Column), square(Newrow, Newcolumn)) :-
    Row =< 6,
    Newrow is Row + 1,
    Column =< 5,
    Newcolumn is Column + 2.

move(square(Row, Column), square(Newrow, Newcolumn)) :-
    Row =< 6,
    Newrow is Row + 2,
    Column >= 2,
    Newcolumn is Column - 1.

move(square(Row, Column), square(Newrow, Newcolumn)) :-
    Row =< 6,
    Newrow is Row + 1,
    Column >= 3,
    Newcolumn is Column - 2.

move(square(Row, Column), square(Newrow, Newcolumn)) :-
    Row >= 2,
    Newrow is Row - 2,
    Column =< 7,
    Newcolumn is Column + 1.

move(square(Row, Column), square(Newrow, Newcolumn)) :-
    Row >= 2,
    Newrow is Row - 1,
    Column =< 5,
    Newcolumn is Column + 2.

% Define the "unsafe" predicate if needed
% unsafe(square(X, Y)) :- X < 1 ; X > 8 ; Y < 1 ; Y > 8.

% Define the main "path" predicate with depth-first search
path(square(StartRow, StartColumn), square(GoalRow, GoalColumn), _) :-
    go([square(StartRow, StartColumn)], square(GoalRow, GoalColumn)).

go([square(GoalRow, GoalColumn) | RestPath], square(GoalRow, GoalColumn)) :-
   % write('A Solution is Found!'), nl,
    reverse([square(GoalRow, GoalColumn) | RestPath], Solution),
    display(Solution).

go([square(CurrentRow, CurrentColumn) | RestPath], square(GoalRow, GoalColumn)) :-
    move(square(CurrentRow, CurrentColumn), square(NextRow, NextColumn)),
    \+ member(square(NextRow, NextColumn), [square(CurrentRow, CurrentColumn) | RestPath]),
    go([square(NextRow, NextColumn), square(CurrentRow, CurrentColumn) | RestPath], square(GoalRow, GoalColumn)).

% Define the "display" predicate to show the path
display([]).
display([square(Row, Column) | Rest]) :-
    display(Rest),
    format('square(~w, ~w) -> ', [Row, Column]).
display([square(Row, Column)]) :-
    format('square(~w, ~w)', [Row, Column]), nl.
