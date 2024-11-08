:- [adts].

% Define your puzzle representation and initial state here
initial_state([handempty, on(a,b), on(b,c),on(c,d),ontable(d),clear(a)]).

%Define empty_list/1
empty_list([]).

% Define breadth-first search
breadth_first_search(State, Goal) :-
    empty_list(Empty_open),
    append(Empty_open,[[State, nil, 0]], Open_list),
    empty_set(Closed_set),
    path_bfs(Open_list, Closed_set, Goal).

path_bfs(Open_list, _, _) :-
    empty_list(Open_list),
    write('No solution found with these rules'), nl.

path_bfs(Open_list, Closed_set, Goal) :-
    list([State, Parent, Depth], Rest_open_list, Open_list),
    State = Goal,
    write('A Solution is Found!'), nl,
    printsolution([State, Parent, Depth], Closed_set).

path_bfs(Open_list, Closed_set, Goal) :-
    list([State, Parent, Depth], Rest_open_list, Open_list),
    get_children_bfs(State, Depth, Rest_open_list, Closed_set, Children),
    add_list_to_list(Children, Rest_open_list, New_open_list),
    union([[State, Parent, Depth]], Closed_set, New_closed_set),
    path_bfs(New_open_list, New_closed_set, Goal), !.

get_children_bfs(State, Depth, Rest_open_list, Closed_set, Children) :-
    bagof(Child, moves(State, Depth, Rest_open_list, Closed_set, Child), Children);
    empty_set(Children).

% The moves and printsolution predicates remain the same

% Run the breadth-first search
solve_breadth_first :-
    initial_state(InitialState),
    breadth_first_search(InitialState, 7). % Change 7 to your goal state

% Call solve_breadth_first to test
