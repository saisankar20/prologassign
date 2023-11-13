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

display([]).
display([H|T]) :- display(T), write(H), nl.

path(X,X,L):-display(L).
path(X,Y,L):-move(X,Z),not(member(Z,L)),path(Z,Y,[Z|L]).
