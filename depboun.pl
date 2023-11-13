% This is obtained from depth1 by modifying the moves predicate to include a
% variable Depth which can be used to define a bound.  This is done with the
% line "Depth < ?" where ? is a numeric bound.

:- [adts].

move(1,6).
move(1,8).
move(2,7).
move(2,9).
move(3,4).
move(3,8).
move(4,3).
move(4,9).
move(6,7).
move(6,1).
move(7,6).
move(7,2).
move(8,3).
move(8,1).
move(9,4).
move(9,2).

%unsafe(0).

%%%%% Depth first path "shell" algorithm modified to do bounded search %%%%%%%

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
        Depth  < 5,
        move(State, Next),
%        not(unsafe(Next)),
        not(member_stack([Next, _, _], Rest_open_stack)),
        not(member_set([Next, _, _], Closed_set)),
        New_Depth is Depth + 1.

printsolution([State, nil, Depth], _) :-
        write(State), write(' '), write(Depth), nl.

printsolution([State, Parent, Depth], Closed_set) :-
        member_set([Parent, Grandparent, Next_Depth], Closed_set),
        printsolution([Parent, Grandparent, Next_Depth], Closed_set),
        write(State), write(' '), write(Depth), nl.
