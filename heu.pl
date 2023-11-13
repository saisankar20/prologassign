:- [adts].

move(1, 2).
move(1, 4).
move(2, 1).
move(2, 3).
move(2, 5).
move(3, 2).
move(3, 6).
move(4, 1).
move(4, 5).
move(4, 7).
move(5, 2).
move(5, 4).
move(5, 6).
move(5, 8).
move(6, 3).
move(6, 5).
move(6, 9).
move(7, 4).
move(7, 8).
move(8, 5).
move(8, 7).
move(8, 9).
move(9, 6).
move(9, 8).


% Replace empty_priority_queue with empty_queue
empty_queue([]).

% Heuristic function: Count the number of tiles out of place
heuristic(State, H) :-
    goal(Goal),
    findall(Tile, (nth1(I, State, S), nth1(I, Goal, G), S \= G), TilesOutOfPlace),
    length(TilesOutOfPlace, H).

go_best_first(Start) :-
    empty_priority_queue(Empty_open),
    heuristic(Start, H),
    enqueue([Start, nil, 0, H], Empty_open, Open_pq),
    empty_set(Closed_set),
    path_best_first(Open_pq, Closed_set).

path_best_first(Open_pq, _) :-
    empty_priority_queue(Open_pq),
    write('No solution found with these rules').

path_best_first(Open_pq, Closed_set) :-
    dequeue([State, Parent, Depth, _], Rest_open_pq, Open_pq),
    State = goal,
    write('A Solution is Found!'), nl,
    printsolution([State, Parent, Depth], Closed_set).

path_best_first(Open_pq, Closed_set) :-
    dequeue([State, Parent, Depth, _], Rest_open_pq, Open_pq),
    get_children_best_first(State, Depth, Rest_open_pq, Closed_set, Children),
    add_list_to_priority_queue(Children, Rest_open_pq, New_open_pq),
    union([[State, Parent, Depth]], Closed_set, New_closed_set),
    path_best_first(New_open_pq, New_closed_set), !.

get_children_best_first(State, Depth, Rest_open_pq, Closed_set, Children) :-
    bagof(Child, moves(State, Depth, Rest_open_pq, Closed_set, Child), Children);
    empty_set(Children).

moves(State, Depth, Rest_open_pq, Closed_set, [Next, State, New_Depth, H]) :-
    Depth < 20,  % Set a depth limit to avoid infinite loops
    move(State, Next),
    not(member_priority_queue([Next, _, _, _], Rest_open_pq)),
    not(member_set([Next, _, _], Closed_set)),
    New_Depth is Depth + 1,
    heuristic(Next, H).

printsolution([State, nil, Depth], _) :-
    write(State), write(' '), write(Depth), nl.

printsolution([State, Parent, Depth], Closed_set) :-
    member_set([Parent, Grandparent, Next_Depth], Closed_set),
    printsolution([Parent, Grandparent, Next_Depth], Closed_set),
    write(State), write(' '), write(Depth), nl.

% Define predicates for running with and without heuristic
go_with_heuristic(Start) :-
    write('Using Heuristic:'), nl,
    go_best_first(Start),
    nl.

go_without_heuristic(Start) :-
    write('Without Heuristic:'), nl,
    go_best_first(Start),
    nl.
