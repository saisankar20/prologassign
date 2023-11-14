:- [adts].
move([0,C2,C3,C4,C5,C6,C7,C8,C9],[C2,0,C3,C4,C5,C6,C7,C8,C9]).
move([0,C2,C3,C4,C5,C6,C7,C8,C9],[C4,C2,C3,0,C5,C6,C7,C8,C9]).
move([C1,0,C3,C4,C5,C6,C7,C8,C9],[0,C1,C3,C4,C5,C6,C7,C8,C9]).
move([C1,0,C3,C4,C5,C6,C7,C8,C9],[C1,C3,0,C4,C5,C6,C7,C8,C9]).
move([C1,0,C3,C4,C5,C6,C7,C8,C9],[C1,C5,C3,C4,0,C6,C7,C8,C9]).
move([C1,C2,0,C4,C5,C6,C7,C8,C9],[C1,0,C2,C4,C5,C6,C7,C8,C9]).
move([C1,C2,0,C4,C5,C6,C7,C8,C9],[C1,C2,C6,C4,C5,0,C7,C8,C9]).
move([C1,C2,C3,0,C5,C6,C7,C8,C9],[0,C2,C3,C1,C5,C6,C7,C8,C9]).
move([C1,C2,C3,0,C5,C6,C7,C8,C9],[C1,C2,C3,C5,0,C6,C7,C8,C9]).
move([C1,C2,C3,0,C5,C6,C7,C8,C9],[C1,C2,C3,C7,C5,C6,0,C8,C9]).
move([C1,C2,C3,C4,0,C6,C7,C8,C9],[C1,0,C3,C4,C2,C6,C7,C8,C9]).
move([C1,C2,C3,C4,0,C6,C7,C8,C9],[C1,C2,C3,0,C4,C6,C7,C8,C9]).
move([C1,C2,C3,C4,0,C6,C7,C8,C9],[C1,C2,C3,C4,C6,0,C7,C8,C9]).
move([C1,C2,C3,C4,0,C6,C7,C8,C9],[C1,C2,C3,C4,C8,C6,C7,0,C9]).
move([C1,C2,C3,C4,C5,0,C7,C8,C9],[C1,C2,0,C4,C5,C3,C7,C8,C9]).
move([C1,C2,C3,C4,C5,0,C7,C8,C9],[C1,C2,C3,C4,0,C5,C7,C8,C9]).
move([C1,C2,C3,C4,C5,0,C7,C8,C9],[C1,C2,C3,C4,C5,C9,C7,C8,0]).
move([C1,C2,C3,C4,C5,C6,0,C8,C9],[C1,C2,C3,0,C5,C6,C4,C8,C9]).
move([C1,C2,C3,C4,C5,C6,0,C8,C9],[C1,C2,C3,C4,C5,C6,C8,0,C9]).
move([C1,C2,C3,C4,C5,C6,C7,0,C9],[C1,C2,C3,C4,C5,C6,0,C7,C9]).
move([C1,C2,C3,C4,C5,C6,C7,0,C9],[C1,C2,C3,C4,C5,C6,C7,C9,0]).
move([C1,C2,C3,C4,C5,C6,C7,0,C9],[C1,C2,C3,C4,0,C6,C7,C5,C9]).
move([C1,C2,C3,C4,C5,C6,C7,C8,0],[C1,C2,C3,C4,C5,0,C7,C8,C6]).
move([C1,C2,C3,C4,C5,C6,C7,C8,0],[C1,C2,C3,C4,C5,C6,C7,0,C8]).

test:-go([2,8,3,1,6,4,7,0,5],[1,2,3,8,0,4,7,6,5]).

heuristic(X,Y,0).

% If the first argument is some state and the second argument is the goal,
% the third argument evaluates to the number of tiles out of place.
%heuristic([],[],0).
%heuristic([H1|T1],[H2|T2],V1):-H1=:=0,heuristic(T1,T2,V1).
%heuristic([H1|T1],[H2|T2],V1):-H1=:=H2,heuristic(T1,T2,V1).
%heuristic([H1|T1],[H2|T2],V2):-H1=\=H2,heuristic(T1,T2,V1),V2 is V1+1.

precedes([_,_,_,_,F1], [_,_,_,_,F2]) :- F1 =< F2.

%%%%%%% Best first search algorithm%%%%%%%%%
% go initializes Open and CLosed and calls path

go(Start, Goal) :-
    empty_set(Closed_set),
    empty_pq(Open),
    heuristic(Start, Goal, H),
    insert_pq([Start, nil, 0, H, H], Open, Open_pq),
    path(Open_pq, Closed_set, Goal, 0).
path(Open_pq, _, _, _) :-
    empty_pq(Open_pq),
    write('graph searched, no solution found').

path(Open_pq, Closed_set, Goal, StateCount) :-
    dequeue_pq([State, Parent, _, _, _], Open_pq, _),
    State = Goal,
    write('Solution path is: '), nl,
    printsolution([State, Parent, _, _, _], Closed_set),
    write("State Count = "), write(StateCount).

path(Open_pq, Closed_set, Goal, StateCount) :-
    StateCount_new is StateCount + 1,
    dequeue_pq([State, Parent, D, H, S], Open_pq, Rest_of_open_pq),
    get_children([State, Parent, D, H, S], Rest_of_open_pq, Closed_set,Children, Goal),
    insert_list_pq(Children, Rest_of_open_pq, New_open_pq),
    union([[State, Parent, D, H, S]], Closed_set, New_closed_set),
    path(New_open_pq, New_closed_set, Goal, StateCount_new),!.

get_children([State, _, D, _, _], Rest_of_open_pq, Closed_set, Children,Goal) :-
    bagof(Child, moves([State, _, D, _, _], Rest_of_open_pq,
                       Closed_set, Child, Goal), Children);
    empty_set(Children).

moves([State, _, Depth, _, _], Rest_of_open_pq, Closed_set, [Next, State, New_D, H, S], Goal) :-
    move(State, Next),
    % not(unsafe(Next)),
    not(member_pq([Next, _, _, _, _], Rest_of_open_pq)),
    not(member_set([Next, _, _, _, _], Closed_set)),
    New_D is Depth + 1,
    heuristic(Next, Goal, H),
    S is New_D + H.

% Printsolution prints out the solution path by tracing
% back through the states on closed using parent links.

printsolution([State, nil, _, _, _], _):-
    write(State), nl.

printsolution([State, Parent, _, _, _], Closed_set) :-
    member_set([Parent, Grandparent, _, _, _], Closed_set),
    printsolution([Parent, Grandparent, _, _, _], Closed_set),
    write(State), nl.
