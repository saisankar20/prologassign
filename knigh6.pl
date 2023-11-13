% Define helper predicates for comparison
less_than_or_equals(A, B) :- A =< B.
greater_than_or_equals(A, B) :- A >= B.
equals(A, B) :- A is B.

% Define the valid knight's moves using the given rules
move(square(Row, Column), square(Newrow, Newcolumn)) :-
    less_than_or_equals(Row, 6),
    equals(Newrow, Row + 2),
    less_than_or_equals(Column, 7),
    equals(Newcolumn, Column + 1).

move(square(Row, Column), square(Newrow, Newcolumn)) :-
    less_than_or_equals(Row, 6),
    equals(Newrow, Row + 1),
    less_than_or_equals(Column, 5),
    equals(Newcolumn, Column + 2).

move(square(Row, Column), square(Newrow, Newcolumn)) :-
    less_than_or_equals(Row, 6),
    equals(Newrow, Row + 2),
    greater_than_or_equals(Column, 2),
    equals(Newcolumn, Column - 1).

move(square(Row, Column), square(Newrow, Newcolumn)) :-
    less_than_or_equals(Row, 6),
    equals(Newrow, Row + 1),
    greater_than_or_equals(Column, 3),
    equals(Newcolumn, Column - 2).

move(square(Row, Column), square(Newrow, Newcolumn)) :-
    greater_than_or_equals(Row, 2),
    equals(Newrow, Row - 2),
    less_than_or_equals(Column, 7),
    equals(Newcolumn, Column + 1).

move(square(Row, Column), square(Newrow, Newcolumn)) :-
    greater_than_or_equals(Row, 2),
    equals(Newrow, Row - 1),
    less_than_or_equals(Column, 5),
    equals(Newcolumn, Column + 2).

move(square(Row, Column), square(Newrow, Newcolumn)) :-
    greater_than_or_equals(Row, 2),
    equals(Newrow, Row - 2),
    greater_than_or_equals(Column, 2),
    equals(Newcolumn, Column - 1).

move(square(Row, Column), square(Newrow, Newcolumn)) :-
    greater_than_or_equals(Row, 2),
    equals(Newrow, Row - 1),
    greater_than_or_equals(Column, 3),
    equals(Newcolumn, Column - 2).

% Define the "path" predicate to find a path from X to Y
path(X, X, _L) :- display([]).

path(X, Y, L) :-
    move(X, Z),
    not(member(Z, L)),
    path(Z, Y, [Z | L]).

% Define the "display" predicate to print the path
display([]).
display([H | T]) :-
    display(T),
    write(H),
    nl.

% Query to find a path from cell (1,1) to cell (8,8)
?- path(square(1,1), square(8,8), [square(1,1)]).
