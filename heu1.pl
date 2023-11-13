:-  [adts].
move([0/X1/X2/X3/X4/X5/X6/X7/X8], [X1/0/X2/X3/X4/X5/X6/X7/X8]).
move( [0/X1/X2/X3/X4/X5/X6/X7/X8], [X3/X1/X2/0/X4/X5/X6/X7/X8]).
move([X1/0/X2/X3/X4/X5/X6/X7/X8], [0/X1/X2/X3/X4/X5/X6/X7/X8]).
move([X1/0/X2/X3/X4/X5/X6/X7/X8], [X1/X2/0/X3/X4/X5/X6/X7/X8]).
move([X1/0/X2/X3/X4/X5/X6/X7/X8], [X1/X4/X2/X3/0/X5/X6/X7/X8]).
move([X1/X2/0/X3/X4/X5/X6/X7/X8], [X1/0/X2/X3/X4/X5/X6/X7/X8]).
move([X1/X2/0/X3/X4/X5/X6/X7/X8], [X1/X2/X5/X3/X4/0/X6/X7/X8]).
move([X1/X2/X3/0/X4/X5/X6/X7/X8], [0/X2/X3/X1/X4/X5/X6/X7/X8]).
move([X1/X2/X3/0/X4/X5/X6/X7/X8], [X1/X2/X3/X4/0/X5/X6/X7/X8]).
move([X1/X2/X3/0/X4/X5/X6/X7/X8], [X1/X2/X3/X6/X4/X5/0/X7/X8]).
move([X1/X2/X3/X4/0/X5/X6/X7/X8], [X1/0/X3/X4/X2/X5/X6/X7/X8]).
move([X1/X2/X3/X4/0/X5/X6/X7/X8], [X1/X2/X3/X4/X5/0/X6/X7/X8]).
move([X1/X2/X3/X4/0/X5/X6/X7/X8], [X1/X2/X3/X4/X7/X5/X6/0/X8]).
move([X1/X2/X3/X4/0/X5/X6/X7/X8], [X1/X2/X3/0/X4/X5/X6/X7/X8]).
move([X1/X2/X3/X4/X5/0/X6/X7/X8], [X1/X2/0/X4/X5/X3/X6/X7/X8]).
move([X1/X2/X3/X4/X5/0/x6/X7/X8], [X1/X2/X3/X4/X5/X8/x6/X7/0]).
move([X1/X2/X3/X4/X5/0/X6/X7/X8], [X1/X2/X3/X4/0/X5/X6/X7/X8]).
move([X1/X2/X3/X4/X5/X6/0/X7/X8], [X1/X2/X3/0/X5/X6/X4/X7/X8]).
move([X1/X2/X3/X4/X5/X6/0/X7/X8], [X1/X2/X3/X4/X5/X6/X7/0/X8]).
move([X1/X2/X3/X4/X5/X6/X7/0/X8], [X1/X2/X3/X4/0/x6/x7/X5/X8]).
move([X1/X2/X3/X4/X5/X6/X7/0/X8], [X1/X2/X3/X4/X5/X6/X7/X8/0]).
move([X1/X2/X3/X4/X5/X6/x7/0/X8], [X1/X2/X3/X4/X5/X6/0/X7/X8]).
move([X1/X2/X3/X4/X5/X6/X7/X8/0], [X1/X2/X3/X4/X5/0/X7/X8/X6]).
move([X1/X2/X3/X4/X5/X6/X7/X8/0], [X1/X2/X3/X4/X5/X6/X7/0/X8]).
%unsafe (0).
heuristic([A1/B1/C1/D1/E1/F1/G1/H1/I1], [A2/B2/C2/D2/E2/F2/G2/H2/12], N) :-
check(A1, A2, N1), check(B1, B2, N2), check(C1, C2, N3),
check(D1, D2, N4), check(El, E2, N5), check(F1, F2, N6),
check(G1, G2, N7), check(H1, H2, N8), check(I1, I2, N9),
N is N1+N2+N3+N4+N5+N6+N7+N8+N9.
check(X,Y,S) :- X \= Y, !, S is 1.
check(_,_,0).
precedes( [_,_,_,_,F1], [_,_,_,_,F2]) :- F1 =< F2.
go(Start, Goal) :-
empty_set(Closed_set),
empty_pq(Open),
heuristic(Start, Goal, H),
insert_pq([Start, nil, 0, H, H], Open, Open_pq),
path(Open_pq, Closed_set, Goal).

path(Open_pq, _, _):-
empty_pq(Open_pq),
write('graph searched, no solution found').
%The next record is a goal
%#Print out the list of visited states
path(Open_pq, Closed_set, Goal) :-
dequeue_pq( [State, Parent, _, _, _], Open_pq, _),
State = Goal,
write('Solution path is: '), nl,
printsolution([State, Parent, _, _, _], Closed_set), n1,
write('Size of open Queue is:'), n1,
size(Open_pq, N), write(N).
%#The next record is not equal to the goal
%#Generate its children, add to open and continue
path(Open_pq, Closed_set, Goal) :-
dequeue_pq([State, Parent, D, H, S], Open_pq, Rest_of_open_pq),
get_children([State, Parent, D, H, S], Rest_of_open_pq, Closed_set,
Children, Goal),
insert_list_pq(Children, Rest_of_open_pq, New_open_pq),
union([[State, Parent, D, H, S]], Closed_set, New_closed_set),
path(New_open_pq, New_closed_set, Goal), !.
get_children([State, _, D, _ ,_], Rest_of_open_pq, Closed_set, Children,Goal) :-
bagof(Child, moves( [State, _, D, _, _], Rest_of_open_pq,
Closed_set, Child, Goal), Children);
empty_set(Children).

moves([State, Depth, _,_], Rest_of_open_pq, Closed_set,
[Next, State, New_D, H, S], Goal) :-
move(State, Next),
not(unsafe(Next)),
not(member_pq( [Next,_, _,_, _], Rest_of_open_pq)),
not(member_set([Next, _, _, _, _],closed_set)),
New_D is Depth + 1,
heuristic(Next, Goal, H),
S is New_D + H.
printsolution([State, nil, _, _, _], _):-
write(State), n1.
printsolution([State, Parent, _, _, _], Closed_set)  :-
member_set([Parent, Grandparent, _, _,_], closed_set),
printsolution([Parent, Grandparent, _, _, _], closed_set),
write(State), n1.
size([],0).
size([H|T], N) :- size(T, N1), N is N1+1.
writelist([]).
writelist([H|T]):-write(H), nl, writelist(T).
