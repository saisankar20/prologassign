
:- [adts].
move([C1,0,C3, C4,C5,C6, C7,C8,C9],
     [0,C1,C3, C4,C5,C6, C7,C8,C9]).
move([C1,x2,0, C4,C5,C6, C7,C8,C9],
     [C1,0,X2, C4,C5,C6, C7,C8,C9]).
move([C1,x2,C3, C4,0,C6,C7,C8,C9],
     [C1,x2,C3, 0,C4,C6,C7,C8,C9]).
move([C1,x2,C3, C4,C5,0,C7,C8,C9],
     [C1,x2,C3, C4,0,C5,C7,C8,C9]).
move([C1,x2,C3, C4,C5,C6, C7,0,C9],
     [C1,x2,C3, C4,C5,C6, 0,C7,C9]).
move([C1,x2,C3, C4,C5,C6, C7,C8,0],
     [C1,x2,C3, C4,C5,C6, C7,0,C8]).
move([0,x2,C3, C4,C5,C6, C7,C8,C9],
     [x2,0,C3, C4,C5,C6, C7,C8,C9]).
move([C1,0,C3, C4,C5,C6, C7,C8,C9],
     [C1,C3,0, C4,C5,C6, C7,C8,C9]).
move([C1,X2,C3, 0,C5,C6, C7,C8,C9],
     [C1,x2,C3, C5,0,C6, C7,C8,C9]).
move([C1,x2,C3, C4,0,C6, C7,C8,C9],
     [C1,x2,C3, C4,C6,0, C7,C8,C9]).
move([C1,x2,C3, C4,C5,C6,0,C8,C9],
     [C1,x2,C3, C4,C5,C6,C8,0,C9]).
move([C1,x2,C3, C4,C5,C6,C7,0,C9],
     [C1,x2,C3, C4,C5,C6,C7,C9,0]).
move([C1,x2,C3, 0,C5,C6, C7,C8,C9],
     [0,x2,C3, C1,C5,C6, C7,C8,C9]).
move([C1,x2,C3, C4,0,C6, C7,C8,C9],
     [C1,0,C3, C4,X2,C6, C7,C8,C9]).
move([C1,x2,C3, C4,C5,0, C7,C8,C9],
     [C1,x2,0, C4,C5,C3, C7,C8,C9]).
move([C1,x2,C3, C4,C5,C6, C7,0,C9],
     [C1,x2,C3, C4,0,C6, C7,C5,C9]).
move([C1,x2,C3, C4,C5,C6, C7,C8,0],
     [C1,x2,C3, C4,C5,0, C7,C8,C6]).
move([C1,x2,C3, C4,C5,C6, 0,C8,C9],
     [C1,x2,C3, 0,C5,C6, C4,C8,C9]).
move([0,x2,C3, C4,C5,C6, C7,C8,C9],
     [C4,X2,C3, 0,C5,C6, C7,C8,C9]).
move([C1,0,C3, C4,C5,C6, C7,C8,C9],
     [C1,C5,C3, C4,0,C6, C7,C8,C9]).
move([C1,X2,0, C4,C5,C6, C7,C8,C9],
     [C1,x2,C6, C4,C5,0, C7,C8,C9]).
move([C1,x2,C3, 0,C5,C6, C7,C8,C9],
     [C1,x2,C3, C7,C5,C6, 0,C8,C9]).
move([C1,x2,C3, C4,0,C6, C7,C8,C9],
     [C1,x2,C3, C4,C8,C6, C7,0,C9]).
move([C1,x2,C3, C4,C5,0, C7,C8,C9],
     [C1,x2,C3, C4,C5,C9, C7,C8,0]).

unsafe(0).

heuristic([],[],0).
heuristic([H1|T1],[H2|T2],V1):-H1=:=0,heuristic(T1, T2,V1).
heuristic([H1�T1],[H2|T2],V1):-H1=:=H2,heuristic(T1, T2,V1).
heuristic([H1|T1],[H2|T2],V2):-H1=\=H2,heuristic(T1, T2,V1), V2 is V1+1.


precedes([_,_,_,_,F1], [_,_,_,_,F2]) :- F1 =< F2.
go(Start, Goal) :-
        empty_set(closed_set),
        empty_pq(Open),
        heuristic(Start, Goal, H),
        insert_pq([Start, nil, 0, H, H], Open, Open_pq),
        path(Open_pq, Closed_set, Goal).
path(Open_pq, _, _) :-
         empty_pq(Open_pq),
         write('graph searched, no solution found').

path(Open_pq, Closed_set, Goal) :-
         dequeue_pq([State, Parent,_, _, _], Open_pq, _),
         State = Goal,
         write('Solution path is: ), nl,
         printsolution([State, Parent, _, _, _), Closed_set).

path(Open_pq, Closed_set, Goal) :-
        dequeue_pq([State, Parent, D, H, S], Open_pq, Rest_of_open_pq),
        get_children([State, Parent, D, H, S], Rest_of_open_pq, Closed_set, Children, Goal),
        insert_list_pq(Children, Rest_of_open_pq, New_open_pq),
        union([[State, Parent, D, H, S]], Closed_set, New_closed_set),
        path(New_open_pq, New_closed_set, Goal),!.

get_children([State, _, D, _, _], Rest_of_open_pq, Closed_set, Children, Goal) :-

        bagof (Child, moves([State, _, D, _, _], Rest_of_open_pq, closed_set, Child, Goal), Children);
        empty_set(Children).
moves([State, _, Depth, _, _], Rest_of_open_pq, Closed_set,[Next, State, New_D, H, S], Goal) :-
         move (State, Next),
         % not (unsafe(Next)),
         not (member_pq([Next, _, _, _, _], Rest_of_open_pq)),
         not (member_set([Next, _, _, _, _], Closed_set)),
         New_D is Depth + 1,
         heuristic (Next, Goal, H),
         S is New D + H.

printsolution([State, nil, _, _], _):-
        write(State), nl.
printsolution ([State, Parent, _, _, _], Closed_set) :-
        member_set([Parent, Grandparent, _, _, _], Closed_set),
        printsolution([Parent, Grandparent, _, _, _1, Closed_set),
        write(State), nl.
