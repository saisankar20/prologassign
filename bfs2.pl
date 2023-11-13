:- [adts].

move(1, 6).
move(1, 8).
move(2, 7).
move(2, 9).
move(3, 4).
move(3, 8).
move(4, 3).
move(4, 9).
move(6, 7).
move(6, 1).
move(7, 6).
move(7, 2).
move(8, 3).
move(8, 1).
move(9, 4).
move(9, 2).

go(Start, Goal) :-
    empty_queue(Empty_open),
    enqueue([Start, nil, 0], Empty_open, Open_queue),
    empty_set(Closed_set),
    path(Open_queue, Closed_set, Goal).

path(Open_queue, _, _) :-
    empty_queue(Open_queue),
    write('No solution found with these rules').

path(Open_queue, Closed_set, Goal) :-
    dequeue([State, Parent, Depth], Rest_open_queue, Open_queue),
    State = Goal,
    write('A Solution is Found!'), nl,
    printsolution([State, Parent, Depth], Closed_set).

path(Open_queue, Closed_set, Goal) :-
    dequeue([State, Parent, Depth], Rest_open_queue, Open_queue),
    get_children(State, Depth, Rest_open_queue, Closed_set, Children),
    add_list_to_queue(Children, Rest_open_queue, New_open_queue),
    union([[State, Parent, Depth]], Closed_set, New_closed_set),
    path(New_open_queue, New_closed_set, Goal), !.

get_children(State, Depth, Rest_open_queue, Closed_set, Children):-
    bagof(Child, moves(State, Depth, Rest_open_queue, Closed_set, Child), Children);
    empty_set(Children).

moves(State, Depth, Rest_open_queue, Closed_set, [Next, State, New_Depth]):-
    Depth < 5,
    move(State, Next),
    not(member_queue([Next, _, _], Rest_open_queue)),
    not(member_set([Next, _, _], Closed_set)),
    New_Depth is Depth + 1.

printsolution([State, nil, Depth], _) :-
    write(State), write(' '), write(Depth), nl.

printsolution([State, Parent, Depth], Closed_set) :-
    member_set([Parent, Grandparent, Next_Depth], Closed_set),
    printsolution([Parent, Grandparent, Next_Depth], Closed_set),
    write(State), write(' '), write(Depth), nl.
