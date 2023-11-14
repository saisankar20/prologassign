:- [adts].

move((0,C2,C3, C4,C5,C6, C7,C8,C9) , (C2,0,C3, C4,C5,C6, C7,C8,C9)).
move((C1,0,C3, C4,C5,C6, C7,C8,C9) , (C1,C3,0, C4,C5,C6, C7,C8,C9)).
move((C1,0,C3, C4,C5,C6, C7,C8,C9) , (C1,C5,C3, C4,0,C6, C7,C8,C9)).
move((C1,0,C3, C4,C5,C6,C7,C8,C9) , (0,C1,C3,C4,C5,C6,C7,C8,C9)).
move((C1,C2,0, C4,C5,C6, C7,C8,C9) , (C1,0,C2, C4,C5,C6, C7,C8,C9)).
move((0,C2,C3, C4,C5,C6, C7,C8,C9) , (C4,C2,C3, 0,C5,C6, C7,C8,C9)).
move((C1,C2,C3, 0,C5,C6, C7,C8,C9) , (C1,C2,C3, C7,C5,C6, 0,C8,C9)).
move((C1,C2,C3, C4,0,C6, C7,C8,C9) , (C1,C2,C3, 0,C4,C6, C7,C8,C9)).
move((C1,C2,C3, C4,C5,C6, C7,C8,0) , (C1,C2,C3, C4,C5,C6, C7,0,C8)).
move((C1,C2,C3, C4,C5,C6, C7,C8,0) , (C1,C2,C3, C4,C5,0, C7,C8,C6)).
move((C1,C2,C3, C4,0,C6, C7,C8,C9) , (C1,C2,C3, C4,C6,0,C7,C8,C9)).
move((C1,C2,0, C4,C5,C6, C7,C8,C9) , (C1,C2,C6, C4,C5,0, C7,C8,C9)).
move((C1,C2,C3, 0,C5,C6, C7,C8,C9) , (C1,C2,C3, C5,0,C6, C7,C8,C9)).
move((C1,C2,C3, 0,C5,C6, C7,C8,C9) , (0,C2,C3, C1,C5,C6, C7,C8,C9)).
move((C1,C2,C3, C4,0,C6, C7,C8,C9) , (C1,0,C3, C4,C2,C6, C7,C8,C9)).
move((C1,C2,C3, C4,C5,0, C7,C8,C9) , (C1,C2,C3, C4,C5,C9, C7,C8,0)).
move((C1,C2,C3, C4,C5,C6, 0,C8,C9) , (C1,C2,C3, C4,C5,C6, C8,0,C9)).
move((C1,C2,C3, C4,C5,C6, 0,C8,C9) , (C1,C2,C3, 0,C5,C6, C4,C8,C9)).
move((C1,C2,C3, C4,0,C6, C7,C8,C9) , (C1,C2,C3, C4,C8,C6, C7,0,C9)).
move((C1,C2,C3, C4,C5,0, C7,C8,C9) , (C1,C2,C3, C4,0,C5, C7,C8,C9)).
move((C1,C2,C3, C4,C5,0, C7,C8,C9) , (C1,C2,0, C4,C5,C3, C7,C8,C9)).
move((C1,C2,C3, C4,C5,C6, C7,0,C9) , (C1,C2,C3, C4,C5,C6, 0,C7,C9)).
move((C1,C2,C3, C4,C5,C6, C7,0,C9) , (C1,C2,C3, C4,C5,C6, C7,C9,0)).
move((C1,C2,C3, C4,C5,C6, C7,0,C9) , (C1,C2,C3, C4,0,C6, C7,C5,C9)).

%unsafe(0).
%%%%% Depth first path "shell" algorithm modified to do bounded search %%%%%%%
%
test :- go((2,8,3,1,6,4,7,0,5),(1,2,3,8,0,4,7,6,5)).

go(Start, Goal) :-
	empty_stack(Empty_open),
	stack([Start,nil, 0], Empty_open, Open_stack),
        empty_stack(Closed_set),
        path(Open_stack, Closed_set, Goal).

path(Open_stack,_,_) :-
	empty_stack(Open_stack),
	write('No solution found with these rules').

path(Open_stack, Closed_set, Goal) :-
	stack([State, Parent, Depth], _, Open_stack), State = Goal,
	write('A Solution is Found!'), nl,
	printsolution([State, Parent, Depth], Closed_set).

path(Open_stack, Closed_set, Goal) :-
	stack([State, Parent, Depth], Rest_open_stack, Open_stack),
	get_children(State, Depth, Rest_open_stack, Closed_set, Children),
	add_list_to_stack(Children, Rest_open_stack, New_open_stack),
	union([[State,Parent, Depth]], Closed_set, New_closed_set),
	path(New_open_stack, New_closed_set, Goal), !.

get_children(State, Depth, Rest_open_stack, Closed_set, Children):-
	bagof(Child, moves(State, Depth, Rest_open_stack,
			   Closed_set, Child), Children);
	empty_set(Children).
moves(State, Depth, Rest_open_stack, Closed_set, [Next, State, New_Depth]):-
	Depth < 5,
	move(State, Next),
	% not(unsafe(Next)),
	not(member_stack([Next, _, _], Rest_open_stack)),
	not(member_set([Next, _, _], Closed_set)),
	New_Depth is Depth + 1.

printsolution([State, nil, Depth], _) :-
	write(State), write(' '), write(Depth), nl.

printsolution([State, Parent, Depth], Closed_set) :-
	member_set([Parent, Grandparent, Next_Depth], Closed_set),
	printsolution([Parent, Grandparent, Next_Depth], Closed_set),
	write(State), write(' '), write(Depth), nl.















