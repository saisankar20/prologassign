less_than_or_equals(A,B) :- A =< B.
greater_than_or_equals(A,B) :- A >= B.
equals(A,B) :- A is B.
move(state(R,C) , state(NewR,NewC)) :- less_than_or_equals(R,7), equals(NewR, R+1),
greater_than_or_equals(C,3), equals(NewC, C-2).
move(state(R,C) , state(NewR,NewC)) :- greater_than_or_equals(R,3), equals(NewR, R-2),
less_than_or_equals(C,7), equals(NewC, C+1).
move(state(R,C) , state(NewR,NewC)) :- greater_than_or_equals(R,3), equals(NewR, R-2),
greater_than_or_equals(C,2), equals(NewC, C-1).
move(state(R,C) , state(NewR,NewC)) :- greater_than_or_equals(R,2), equals(NewR, R-1),
greater_than_or_equals(C,3), equals(NewC, C-2).
move(state(R,C) , state(NewR,NewC)) :- less_than_or_equals(R,7), equals(NewR, R+1),
greater_than_or_equals(C,3), equals(NewC, C-2).
move(state(R,C) , state(NewR,NewC)) :- greater_than_or_equals(R,2), equals(NewR, R-1),
less_than_or_equals(C,6), equals(NewC, C+2).
move(state(R,C) , state(NewR,NewC)) :- less_than_or_equals(R,6), equals(NewR, R+2),
greater_than_or_equals(C,2), equals(NewC, C-1).
move(state(R,C) , state(NewR,NewC)) :- less_than_or_equals(R,7), equals(NewR, R+1),
less_than_or_equals(C,6), equals(NewC, C+2).
move(state(R,C) , state(NewR,NewC)) :- less_than_or_equals(R,6), equals(NewR, R+2),
less_than_or_equals(C,7), equals(NewC, C+1).
test :- go(state(1,1), state(8,8)). %unsafe(0).
%%%%% Depth first path "shell" algorithm as found in book %%%%%%% go(Start, Goal) :-
empty_stack(Empty_open),
stack([Start,nil], Empty_open, Open_stack),
empty_stack(Closed_set),
path(Open_stack, Closed_set, Goal).
path(Open_stack,_,_) :-
empty_stack(Open_stack),
write('No solution found with these rules').
path(Open_stack, Closed_set, Goal) :-
stack([State, Parent], _, Open_stack), State = Goal,
write('A Solution is Found!'), nl,
printsolution([State, Parent], Closed_set).
path(Open_stack, Closed_set, Goal) :-
stack([State, Parent], Rest_open_stack, Open_stack),
get_children(State, Rest_open_stack, Closed_set, Children), add_list_to_stack(Children,
Rest_open_stack, New_open_stack), union([[State,Parent]], Closed_set,
New_closed_set),
path(New_open_stack, New_closed_set, Goal), !.
get_children(State, Rest_open_stack, Closed_set, Children):-
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
