:- [adts].

% Define your puzzle representation and initial state here

% Define breadth-first search
breadth_first_search(State, Goal) :-
    empty_queue(Empty_open),
    queue([State, nil, 0], Empty_open, Open_queue),
    empty_set(Closed_set),
    path_bfs(Open_queue, Closed_set, Goal).

path_bfs(Open_queue, _, _) :-
    empty_queue(Open_queue),
    write('No solution found with these rules'), nl.

path_bfs(Open_queue, Closed_set, Goal) :-
    queue([State, Parent, Depth], Rest_open_queue, Open_queue),
    State = Goal,
    write('A Solution is Found!'), nl,
    printsolution([State, Parent, Depth], Closed_set).

path_bfs(Open_queue, Closed_set, Goal) :-
    queue([State, Parent, Depth], Rest_open_queue, Open_queue),
    get_children_bfs(State, Depth, Rest_open_queue, Closed_set, Children),
    add_list_to_queue(Children, Rest_open_queue, New_open_queue),
    union([[State, Parent, Depth]], Closed_set, New_closed_set),
    path_bfs(New_open_queue, New_closed_set, Goal), !.

get_children_bfs(State, Depth, Rest_open_queue, Closed_set, Children) :-
    bagof(Child, moves(State, Depth, Rest_open_queue, Closed_set, Child), Children);
    empty_set(Children).

% The moves and printsolution predicates remain the same

% Run the breadth-first search
solve_breadth_first :-
    initial_state(InitialState),
    breadth_first_search(InitialState, 7). % Change 7 to your goal state

% Call solve_breadth_first to test
