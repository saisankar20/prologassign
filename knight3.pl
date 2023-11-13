% Define helper predicates for comparison
less_than_or_equals(A, B) :- A =< B.
equals(A, B) :- A is B.

% Define the valid knight's moves using the given rules
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

move(square(Row, Column), square(Newrow, Newcolumn)) :-
    Row >= 2,
    Newrow is Row - 2,
    Column >= 2,
    Newcolumn is Column - 1.

move(square(Row, Column), square(Newrow, Newcolumn)) :-
    Row >= 2,
    Newrow is Row - 1,
    Column >= 3,
    Newcolumn is Column - 2.

% Define the "path" predicate to find a path from X to Y
path(X, X, L) :- reverse(L, Path), display(Path).

path(X, Y, L) :-
    move(X, Z),
    not(member(Z, L)),
    path(Z, Y, [Z | L]).

% Define the "display" predicate to print the path
display([]).
display([H | []]) :-
    write(H),
    nl.
display([H | T]) :-
    write(H),
    write(' -> '),
    display(T).
