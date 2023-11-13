:- [adts].
:- style_check(-singleton).

less_than_or_equals(A, B) :- A =< B.
greater_than_or_equals(A, B) :- A >= B.
equals(A, B) :- A is B.


% Define the goal state
goal_state(state(8, 8)).

% Your move predicates as defined in your original code
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

% Depth-first search algorithm
go(Start, Goal) :-
    empty_stack(Empty_open),
    stack([Start, nil], Empty_open, Open_stack),
    empty_stack(Closed_set),
    path(Open_stack, Closed_set, Goal).

path(Open_stack, _, _) :-
    empty_stack(Open_stack),
    write('').

path(Open_stack, Closed_set, Goal) :-
    stack([State, Parent], Rest_open_stack, Open_stack),
    State = Goal,
    write('A Solution is Found!'), nl,
    printsolution([State, Parent], Closed_set).

path(Open_stack, Closed_set, Goal) :-
    stack([State, Parent], Rest_open_stack, Open_stack),
    get_children(State, Rest_open_stack, Closed_set, Children),
    add_list_to_stack(Children, Rest_open_stack, New_open_stack),
    union([[State, Parent]], Closed_set, New_closed_set),
    path(New_open_stack, New_closed_set, Goal), !.

get_children(State, Rest_open_stack, Closed_set, Children) :-
    bagof(Child, moves(State, Rest_open_stack, Closed_set, Child), Children);
    empty_set(Children).

moves(State, Rest_open_stack, Closed_set, [Next, State]) :-
    move(State, Next),
    not(member_stack([Next, _], Rest_open_stack)),
    not(member_set([Next, _], Closed_set)).

printsolution([State, nil], _) :-
    write(State), nl.

printsolution([State, Parent], Closed_set) :-
    member_set([Parent, Grandparent], Closed_set),
    printsolution([Parent, Grandparent], Closed_set),
    write(State), nl.

% Run the search from (1,1) to (8,8)
:- go(state(1, 1), goal_state).
