:- [adts].
%move right
move([A, 0, C, D, E, F, G, H, I], [0, A, C, D, E, F, G, H, I]).
move([A, B, 0, D, E, F, G, H, I], [A, 0, B, D, E, F, G, H, I]).
%move left
move([A, B, C, D, E, F, G, H, I], [A, B, C, D, E, F, G, H, I]).
move([A, B, C, D, E, F, G, H, I], [A, B, C, D, E, F, G, H, I]).
%move down
move([A, B, C, 0, E, F, G, H, I], [0, B, C, A, E, F, G, H, I]).
move([A, B, C, D, 0, F, G, H, I], [A, 0, C, D, B, F, G, H, I]).
move([A, B, C, D, E, 0, G, H, I], [A, B, 0, D, E, C, G, H, I]).
%Middle row movements
%move right
move([A, B, C, D, 0, F, G, H, I], [A, B, C, 0, D, F, G, H, I]).
move([A, B, C, D, E, 0, G, H, I], [A, B, C, D, 0, E, G, H, I]).
%move left
move([A, B, C, 0, E, F, G, H, I], [A, B, C, E, 0, F, G, H, I]).
move([A, B, C, D, 0, F, G, H, I], [A, B, C, D, F, 0, G, H, I]).
%move up
move([0, B, C, D, E, F, G, H, I], [D, B, C, 0, E, F, G, H, I]).
move([A, 0, C, D, E, F, G, H, I], [A, E, C, D, 0, F, G, H, I]).
move([A, B, 0, D, E, F, G, H, I], [A, B, F, D, E, 0, G, H, I]).
%move down
move([A, B, C, D, E, F, 0, H, I], [A, B, C, 0, E, F, D, H, I]).
move([A, B, C, D, E, F, G, 0, I], [A, B, C, D, 0, F, G, E, I]).
move([A, B, C, D, E, F, G, H, 0], [A, B, C, D, E, 0, G, H, F]).
%bottom row movements
%move right
move([A, B, C, D, E, F, G, 0, I], [A, B, C, D, E, F, 0, G, I]).
move([A, B, C, D, E, F, G, H, 0], [A, B, C, D, E, F, G, 0, H]).
%move left
move([A, B, C, D, E, F, 0, H, I], [A, B, C, D, E, F, H, 0, I]).
move([A, B, C, D, E, F, G, 0, I], [A, B, C, D, E, F, G, I, 0]).
%move up
move([A, B, C, 0, E, F, G, H, I], [A, B, C, G, E, F, 0, H, I]).
move([A, B, C, D, 0, F, G, H, I], [A, B, C, D, H, F, G, 0, I]).
move([A, B, C, D, E, 0, G, H, I], [A, B, C, D, E, I, G, H, 0]).
unsafe(0).

go(Start, Goal) :-
   empty_queue(Empty_open_queue),
   enqueue([Start, nil], Empty_open_queue, Open_queue),
   empty_set(Closed_set),
   path(Open_queue, Closed_set, Goal).


path(Open_queue, _, _) :- empty_queue(Open_queue),
       write('graph searched, no solution found').

path(Open_queue, Closed_set, Goal) :-
   dequeue([State, Parent], Open_queue, _),
   State = Goal,
   write('Solution path is: '), nl,
   printsolution([State, Parent], Closed_set).

path(Open_queue, Closed_set, Goal) :-
   dequeue([State, Parent], Open_queue, Rest_of_open_queue),
   get_children(State, Rest_of_open_queue, Closed_set, Children),
   add_list_to_queue(Children, Rest_of_open_queue, New_open_queue),
   union([[State, Parent]], Closed_set, New_closed_set),
   path(New_open_queue, New_closed_set, Goal),!.


get_children(State, Rest_of_open_queue, Closed_set, Children) :-
       bagof(Child, moves(State, Rest_of_open_queue, Closed_set, Child),
            Children);
       empty_set(Children).
moves(State, Rest_of_open_queue, Closed_set, [Next, State]) :-
   move(State, Next),
       not(unsafe(Next)),
   not(member_queue([Next, _], Rest_of_open_queue)),
   not(member_set([Next, _], Closed_set)).


printsolution([State, nil], _):-
   write(State), nl.
printsolution([State, Parent], Closed_set) :-
   not(State = Parent),
   member_set([Parent, Grandparent], Closed_set),
   printsolution([Parent, Grandparent], Closed_set),
   write(State), nl.










