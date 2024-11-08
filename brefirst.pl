:- [adts].
move([C1,0,C3, C4, C5, C6, C7, C8, C9],
     [0,C1,C3, C4, C5, C6, C7, C8, C9]).
move([C1,x2,0, C4, C5, C6, C7, C8,C9],
     [C1,0,x2, C4, C5, C6, C7, C8,C9]).
move([C1,x2,C3, C4,0,C6, C7, C8,C9],
     [C1, X2,C3, 0,C4,C6, C7, C8, C9]).
move([C1, X2,C3, C4, C5,0, C7, C8, C9],
     [C1, X2,C3, C4,0,C5, C7, C8,C9]).
move([C1, X2,C3, C4, C5, C6, C7,0,C9],
     [C1, X2,C3, C4, C5, C6, 0, C7,C9]).
move([C1,x2,C3, C4, C5, C6, C7, C8,0],
     [C1, X2,C3, C4, C5, C6, C7,0,C8]).
move([0,X2,C3, C4, C5, C6, C7, C8, C9],
     [x2,0,C3, C4, C5, C6, C7, C8, C9]).
move([C1,0,C3, C4, C5, C6, C7, C8,c9],
     [C1,C3,0, C4, C5, C6, C7, C8, C9]).
move([C1, X2,C3, 0,C5, C6, C7, C8, C9],
     [C1,x2,C3, C5,0,C6, C7, C8, C9]).
move([C1, X2,C3, C4,0,C6, C7, C8,c9],
     [C1, X2,C3, C4, C6,0, C7, C8, C9]).
move([C1,x2,C3, C4, C5, C6,0,c8,C9],
     [C1,x2,C3, C4, C5, C6,c8,0,C9]).
move([C1,x2,C3, C4, C5, C6, C7,0,C9],
     [C1, X2,C3, C4, C5, C6, C7, C9,0]).
move([C1, X2,C3, 0,C5, C6, C7, C8,C9],
     [0,x2,C3, C1,C5, C6, C7, C8, C9]).
move([C1,x2,C3, C4,0,C6, C7, C8,c9],
     [C1,0,C3, C4,x2, C6, C7, C8, C9]).
move([C1, X2,C3, C4, C5,0, C7, C8, C9],
     [C1,x2,0, C4, C5,C3, C7, C8, C9]).
move([C1, X2,C3, C4, C5, C6, C7,0,C9],
     [C1, X2,C3, C4,0,C6, C7, C5,C9]).
move([C1, X2,C3,C4, C5, C6, C7, C8,0],
     [C1, X2,C3, C4, C5,0, C7, C8, C6]).
move([C1,x2,C3, C4, C5, C6, 0,C8,C9],
     [C1, X2,C3, 0, C5, C6, C4,c8,C9]).
move([0,X2, C3, C4, C5, C6, C7, C8,C9],
     [C4, X2,C3, 0,C5, C6, C7, C8, C9]).
move([C1,0,C3, C4, C5, C6, C7, C8,C9],
     [C1, C5,C3, C4,0,C6, C7, C8, C9]).
move([C1, X2,0, C4, C5, C6, C7, C8,C9],
     [C1, X2,C6, C4, C5,0, C7, C8, C9]).
move([C1, X2,C3, 0,C5, C6, C7, C8, C9],
     [C1, X2,C3, C7, C5, C6, 0,8,9]).
move([C1,x2,C3, C4,0,C6, C7, C8,C9],
     [C1, X2,C3, C4, C8, C6, C7,0,C9]).
move([C1, X2,C3, C4, C5,0, C7, C8, C9],
     [C1, X2,C3, C4, C5,C9, C7, C8,0]).

unsafe(0).

go(Start, Goal) :-

empty_queue(Empty_open_queue),
enqueue([Start, nil], Empty_open_queue, Open_queue),
empty_set(closed_set),
path(Open_queue, Closed_set, Goal).

path(Open_queue,_,_) :- empty_queue(Open_queue),
write('graph searched, no solution found').

path(Open_queue, closed_set, Goal) :-
         dequeue([State, Parent], Open_queue, _),
         State = Goal,
         write(' Solution path is:' ), nl,
         printsolution([State, Parent], Closed_set).

path(Open_queue, Closed_set, Goal) :-
          dequeue([State, Parent], Open_queue, Rest_of_open_queue),					  get_children(State, Rest_of_open_queue, closed_set, Children),
          add_list_to_queue(Children, Rest_of_open_queue, New_open_queue),
          union([[State, Parent]], Closed_set, New_closed_set),
          path(New_open_queue, New_closed_set, Goal),!.

get_children(State, Rest_of_open_queue, Closed_set, Children):-
        bagof(Child, moves(State, Rest_of_open_queue, Closed_set, Child),
              Children);
        empty_set(Children).

moves(State, Rest_of_open_queue, Closed_set, [Next, State]) :-
       move(State, Next),
       not(unsafe(Next)),
       not(member_queue([Next, _], Rest_of_open_queue)),
       not(member_set([Next, _], closed_set)).

print_solution([State, nil],_):-
        write(State), nl.
printsolution([State, Parent], Closed_set) :-
        member_set([Parent, Grandparent ], Closed_set),
        printsolution([Parent, Grandparent], Closed_set),
        write(State), nl.
